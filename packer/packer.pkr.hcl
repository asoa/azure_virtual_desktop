packer {
    required_version = ">= 1.9.1"
    required_plugins {
        azure = {
            version = "~> 2"
            source  = "github.com/hashicorp/azure"
        }
    }
    required_plugins {
        windows-update = {
            version = ">= 0.15.0"
            source  = "github.com/rgl/windows-update"
        }
    }
}

locals { 
    build_version               = formatdate("YY.MM (DD.hhmm)", timestamp())
    build_date                  = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    random_string               = split(uuidv4(), "-")[0]    
}

source "azure-arm" "windows" {
  client_id                        = var.client_id
  client_secret                    = var.client_secret
  subscription_id                  = var.subscription_id
  tenant_id                        = var.tenant_id
  cloud_environment_name           = var.cloud_environment_name
  os_type                          = var.os_type 
  image_publisher                  = var.image_publisher
  image_offer                      = var.image_offer
  image_sku                        = var.image_offer_sku
  // image_version                = var.image_offer_version
  location                         = var.location
  communicator                     = "winrm"
  winrm_insecure                   = true
  winrm_timeout                    = "5m"
  winrm_use_ssl                    = true
  winrm_username                   = "packer"
  vm_size                          = var.vm_size
  azure_tags                       = var.azure_tags
  allowed_inbound_ip_addresses     = var.allowed_inbound_ip_addresses

  # use when using shared image gallery
  shared_image_gallery_destination {
    resource_group  = var.resource_group
    gallery_name    = var.gallery_name
    image_name      = var.image_name
    image_version   = var.image_version
    replication_regions = var.replication_regions
    storage_account_type = var.storage_account_type
  }
  # use when building in existing resource group
  // build_resource_group_name = var.resource_group
  skip_create_image                 = var.skip_create_image
  # temp compute and resource group is useful when developing the template
  temp_compute_name                 = "avd-vm-${var.temp_compute_name}"
  temp_resource_group_name          = "avd-rg-${var.temp_resource_group_name}"
}

build {
  # Build sources
  sources                 = [ "source.azure-arm.windows" ]
  
  
  # windows update
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      // "include:$true",
      "include:$false", # debugging only
    ]
    update_limit = 25
  }

  provisioner "powershell" {
    inline = [
      "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    ]
  }

  provisioner "powershell" {
    inline = [
      "choco install googlechrome -y --checksum E9F6EEFCD3D6A45408AB37546B8C25AFD34D5E368ACE6F26588467830967A33C", 
      "choco install vscode --version 1.87.2 -y",
      "choco install git -y"
    ]
  }

  # istall coder https://coder.com/docs/v2/latest/install
  provisioner "powershell" {
    elevated_user = "SYSTEM"
    elevated_password = ""
    script = "./packer/scripts/coder.ps1"
  }
  # chef stig

  # generalize
  provisioner "powershell" {

    inline = [
      "# If Guest Agent services are installed, make sure that they have started.",
      "foreach ($service in Get-Service -Name RdAgent, WindowsAzureTelemetryService, WindowsAzureGuestAgent -ErrorAction SilentlyContinue) { while ((Get-Service $service.Name).Status -ne 'Running') { Start-Sleep -s 5 } }",

      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
      ]
  }
}
