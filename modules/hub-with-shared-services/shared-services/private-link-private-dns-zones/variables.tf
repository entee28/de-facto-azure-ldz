variable "company_name" {
  description = "The name of the company that owns the private DNS zones."
  type        = string
}

variable "location" {
  description = "The location/region where the private DNS zones will be created."
  type        = string
}

variable "location_code" {
  description = "The location code for the private DNS zones naming."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the private DNS zones will be created."
  type        = string
  default     = null
}

variable "resource_group_role_assignments" {
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
  description = "The role assignments to be created on the private DNS zones resource group."
  default     = {}
}

variable "shared_services_vnet_resource_id" {
  description = "The resource ID of the shared services virtual network."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod') used in resource naming."
  type        = string
  default     = "prd"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
