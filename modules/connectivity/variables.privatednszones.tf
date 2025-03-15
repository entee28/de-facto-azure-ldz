variable "private_dns_zones_resource_group_name" {
  description = "The name of the resource group where the private DNS zones will be created."
  type        = string
  default     = null
}

variable "private_dns_zones_resource_group_role_assignments" {
  type = map(object({
    role_definition_id_or_name = string
    principal_id               = string
    description = optional(string, null)
    skip_service_principal_aad_check = optional(bool, false)
    condition = optional(string, null)
    condition_version = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  description = "The role assignments to be created on the private DNS zones resource group."
  default = {}
}