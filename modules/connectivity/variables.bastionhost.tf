variable "bastion_host_deployment_enabled" {
  type        = bool
  description = "Enable the deployment of the Bastion Host"
  default     = true
}

variable "bastion_host_subnet_address_prefix" {
  type        = string
  description = "The address prefix for the Bastion Host subnet"
  default     = null
}

variable "bastion_host_name" {
  type        = string
  description = "The name of the Bastion Host"
  default     = null
}

variable "bastion_host_copy_paste_enabled" {
  type        = bool
  description = "Enable copy/paste functionality"
  default     = true
}

variable "bastion_host_diagnostic_settings" {
  type = map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
  description = "Diagnostic settings for the Bastion Host"
  default     = {}
}

variable "bastion_host_file_copy_enabled" {
  type        = bool
  description = "Enable file copy functionality"
  default     = false
}

variable "bastion_host_ip_connect_enabled" {
  type        = bool
  description = "Enable IP Connect functionality"
  default     = false
}

variable "bastion_host_kerberos_enabled" {
  type        = bool
  description = "Enable Kerberos functionality"
  default     = false
}

variable "bastion_host_role_assignments" {
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
  description = "Role assignments for the Bastion Host"
  default     = {}
}

variable "bastion_host_scale_units" {
  type        = number
  description = "The number of scale units for the Bastion Host"
  default     = 2
}

variable "bastion_host_session_recording_enabled" {
  type        = bool
  description = "Enable session recording functionality"
  default     = false
}

variable "bastion_host_sharable_recording_enabled" {
  type        = bool
  description = "Enable shareable link functionality"
  default     = false
}

variable "bastion_host_tunneling_enabled" {
  type        = bool
  description = "Enable tunneling functionality"
  default     = false
}

variable "bastion_host_sku" {
  type        = string
  description = "The SKU of the Bastion Host"
  default     = "Standard"
}

variable "bastion_host_tags" {
  type        = map(string)
  description = "Tags for the Bastion Host"
  default     = {}
}

variable "bastion_host_zones" {
  type        = list(number)
  description = "The availability zones for the Bastion Host"
  default     = []
}