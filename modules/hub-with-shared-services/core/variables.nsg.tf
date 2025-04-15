variable "user_network_security_groups" {
  type = map(object({
    name = string
    security_rules = optional(map(object({
      access                                     = string
      description                                = optional(string)
      destination_address_prefix                 = optional(string)
      destination_address_prefixes               = optional(set(string))
      destination_application_security_group_ids = optional(set(string))
      destination_port_range                     = optional(string)
      destination_port_ranges                    = optional(set(string))
      direction                                  = string
      name                                       = string
      priority                                   = number
      protocol                                   = string
      source_address_prefix                      = optional(string)
      source_address_prefixes                    = optional(set(string))
      source_application_security_group_ids      = optional(set(string))
      source_port_range                          = optional(string)
      source_port_ranges                         = optional(set(string))
    })), {})
    diagnostic_settings = optional(map(object({
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
    })), {})
    tags = optional(map(string), {})
  }))
  description = "The user network security groups to be created."
  default     = {}
}
