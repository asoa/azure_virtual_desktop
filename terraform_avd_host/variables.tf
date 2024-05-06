variable "resource_group_location" {
  default     = "eastus"
  description = "Location of the resource group."
}

variable "rdsh_count" {
  description = "Number of AVD machines to deploy"
  default     = 2
}

variable "prefix" {
  type        = string
  default     = "avdtf"
  description = "Prefix of the name of the AVD machine(s)"
}

variable "rg" {
  type        = string
  default     = "#{HOST_POOL_RG_NAME}#"
  description = "resource group name for session hosts"
}

variable "domain_name" {
  type        = string
  default     = "infra.local"
  description = "Name of the domain to join"
}

variable "domain_user_upn" {
  type        = string
  default     = "domainjoineruser" # do not include domain name as this is appended
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "vm_size" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v2"
}

variable "ou_path" {
  default = ""
}

variable "local_admin_username" {
  type        = string
  default     = "tsiadministrator"
  description = "local admin username"
}

variable "local_admin_password" {
  type        = string
  description = "local admin password"
  sensitive   = true
}

variable "vnet_name" {
  type        = string
  description = "name of hostpool vnet created during azure firewall deployment"
}

variable "vnet_resource_group_name" {
  type        = string
  description = "name of hostpool vnet resource group created during azure firewall deployment"
}

variable "compute_gallery_name" {
  type        = string
  description = "Name of the compute gallery to use for the session host"
}

variable "compute_gallery_image_name" {
  type        = string
  description = "Name of the image in the compute gallery to use for the session host"
}

variable "existing_resource_group_name" {
  type        = string
  description = "Name of the resource group where the existing image is located"
}

variable "azurerm_shared_image_existing_location" {
  type        = string
  description = "Location of the existing image"
}

variable "session_host_rg_name" {
  type        = string
  description = "Name of the Resource group in which to deploy the session host"
}