variable "gitlab_apply_stig" {
    type        = bool
    description = "Apply STIG"
    default     = false
}

variable "cloud_environment_name" {
    type        = string
    description = "Cloud Environment Name"
    default     = ""
}

variable "client_id" {
    type        = string
    description = "Azure Client ID"
    default     = ""
}

variable "client_secret" {
    type        = string
    description = "Azure Client Secret"
    default     = ""
}

variable "subscription_id" {
    type        = string
    description = "Azure Subscription ID"
    default     = ""
}

variable "tenant_id" {
    type        = string
    description = "Azure Tenant ID"
    default     = ""
}

variable "os_type" {
    type        = string
    description = "Operating System Type"
    default     = "Windows"
}

variable "image_publisher" {
    type        = string
    description = "Image Publisher"
    default     = ""
}

variable "image_offer" {
    type        = string
    description = "Image Offer"
    default     = ""
}

variable "image_offer_sku" {
    type        = string
    description = "Image Offer SKU"
    default     = ""
}

variable "image_offer_version" {
    type        = string
    description = "Image Offer Version"
    default     = ""
}

variable "location" {
    type        = string
    description = "Azure Location"
    default     = ""
}

variable "vm_size" {
    type        = string
    description = "VM Size"
    default     = ""
}

variable "azure_tags" {
    type        = map(string)
    description = "Azure Tags"
    default     = {}
}

variable "resource_group" {
    type        = string
    description = "Resource Group"
    default     = ""
}

variable "gallery_name" {
    type        = string
    description = "Gallery Name"
    default     = ""
}

variable "image_name" {
    type        = string
    description = "Image Name"
    default     = ""
}

variable "image_version" {
    type        = string
    description = "Image Version"
    default     = ""
}

variable "replication_regions" {
    type        = list(string)
    description = "Replication Regions"
    default     = []
}

variable "storage_account_type" {
    type        = string
    description = "Storage Account Type"
    default     = ""
}

variable "temp_compute_name" {
    type        = string
    description = "Temporary Compute Name"
    default     = ""
}

variable "temp_resource_group_name" {
    type        = string
    description = "Temporary Resource Group Name"
    default     = ""
}

variable "allowed_inbound_ip_addresses" {
    type        = list(string)
    description = "Allowed Inbound IP Addresses"
    default     = []
}

variable "hyper_v_generation" {
    type        = string
    description = "Hyper-V Generation"
    default     = "V2"
}

variable "skip_create_image" {
    type        = bool
    description = "Skip Image Creation"
    default     = true
}
