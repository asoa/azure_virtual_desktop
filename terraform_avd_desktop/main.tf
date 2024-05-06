# create random string
resource "random_string" "random_string" {
  length  = 5
  lower   = false
  numeric = false
  special = false
  upper   = true
}

# Resource group name is output when execution plan is applied.
resource "azurerm_resource_group" "sh" {
  name     = "${var.prefix}-${random_string.random_string.result}"
  location = var.resource_group_location
}

# Create AVD workspace
resource "azurerm_virtual_desktop_workspace" "workspace" {
  name                = "${var.workspace}-${random_string.random_string.result}"
  resource_group_name = azurerm_resource_group.sh.name
  location            = azurerm_resource_group.sh.location
  friendly_name       = "${var.prefix}-WS-${random_string.random_string.result}"
  description         = "${var.prefix}-WS-${random_string.random_string.result}"
}

# Create AVD host pool
resource "azurerm_virtual_desktop_host_pool" "hostpool" {
  resource_group_name      = azurerm_resource_group.sh.name
  location                 = azurerm_resource_group.sh.location
  name                     = "${var.hostpool}-${random_string.random_string.result}"
  friendly_name            = "${var.hostpool}-${random_string.random_string.result}"
  validate_environment     = true
  custom_rdp_properties    = "audiocapturemode:i:1;audiomode:i:0;"
  description              = "${var.prefix}-Terraform-HostPool-${random_string.random_string.result}"
  type                     = "Pooled"
  maximum_sessions_allowed = 16
  load_balancer_type       = "DepthFirst" #[BreadthFirst DepthFirst]
}

resource "azurerm_virtual_desktop_host_pool_registration_info" "registrationinfo" {
  hostpool_id     = azurerm_virtual_desktop_host_pool.hostpool.id
  expiration_date = var.rfc3339
}

# Create AVD DAG
resource "azurerm_virtual_desktop_application_group" "dag" {
  resource_group_name = azurerm_resource_group.sh.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.hostpool.id
  location            = azurerm_resource_group.sh.location
  type                = "Desktop"
  name                = "${var.prefix}-DAG-${random_string.random_string.result}"
  friendly_name       = "${var.prefix}-Desktop-AppGroup-${random_string.random_string.result}"
  description         = "${var.prefix}-Desktop-AppGroup-${random_string.random_string.result}"
  depends_on          = [azurerm_virtual_desktop_host_pool.hostpool, azurerm_virtual_desktop_workspace.workspace]
}

# Associate Workspace and DAG
resource "azurerm_virtual_desktop_workspace_application_group_association" "ws-dag" {
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
  workspace_id         = azurerm_virtual_desktop_workspace.workspace.id
}