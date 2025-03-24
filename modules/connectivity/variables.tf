variable "company_name" {
  description = "The name of the company that owns the hub network."
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID where the hub network will be created."
  type        = string
}

variable "location" {
  description = "The location/region where the hub network will be created."
  type        = string
}

variable "location_code" {
  description = "The location code for the hub network naming."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the hub network will be created."
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
  description = "The role assignments to be created on the hub network resource group."
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
