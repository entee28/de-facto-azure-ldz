variable "hub_vnet_resource_group_name" {
  description = "The name of the resource group where the hub network will be created. If not provided, will use the default naming convention."
  type        = string
  default     = null
}

variable "shared_vnet_resource_group_name" {
  description = "The name of the resource group where the shared services network will be created. If not provided, will use the default naming convention."
  type        = string
  default     = null
}

variable "network_controls_resource_group_name" {
  description = "The name of the resource group where network controls (NSGs and route tables) will be created. If not provided, will use the default naming convention."
  type        = string
  default     = null
}

variable "network_controls_resource_group_role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  description = "The role assignments to be created on the shared services network resource group."
  default     = {}
}
