variable "company_name" {
  type        = string
  description = "(Required) The name of the company or organization."
}

variable "location" {
  type        = string
  description = "(Required) Azure region where the resource should be deployed."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Tags to be applied to the resources."
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "(Optional) The resource group where the resources will be deployed."
  default     = null
}

variable "resource_group_tags" {
  type        = map(string)
  description = "(Optional) Tags to be applied to the resource group."
  default     = {}
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
  description = "Optional. A map of role assignments to create on resource group level."
  default     = {}
}

variable "resource_group_lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  description = "(Optional) Controls the Resource Lock configuration for this resource group."
  default     = null
}

variable "sentinel_onboarding" {
  type = object({
    name                         = optional(string, "default")
    customer_managed_key_enabled = optional(bool, false)
  })
  default = null
}

variable "data_collection_rules" {
  description = "Enables customisation of the data collection rules for Azure Monitor. This is an object with attributes pertaining to the three DCRs that are created by this module."
  type = object({
    change_tracking = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
    vm_insights = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
    defender_sql = object({
      enabled                                                = optional(bool, true)
      name                                                   = string
      location                                               = optional(string, null)
      tags                                                   = optional(map(string), null)
      enable_collection_of_sql_queries_for_security_research = optional(bool, false)
    })
  })
  default = {
    change_tracking = {
      enabled = false
      name    = "dcr-change-tracking-management-prd"
    }
    vm_insights = {
      enabled = false
      name    = "dcr-vm-insights-management-prd"
    }
    defender_sql = {
      enabled = false
      name    = "dcr-defender-sql-management-prd"
    }
  }
}
