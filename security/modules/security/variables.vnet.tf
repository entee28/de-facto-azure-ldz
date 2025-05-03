variable "virtual_network" {
  type = object({
    name          = optional(string, null)
    address_space = set(string)

    bgp_community = optional(string, null)
    ddos_protection_plan = optional(object({
      id     = string
      enable = bool
    }), null)
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
    dns_servers = optional(object({
      dns_servers = set(string)
    }), null)
    enable_vm_protection = optional(bool, false)
    encryption = optional(object({
      enabled     = bool
      enforcement = string
    }), null)
    flow_timeout_in_minutes = optional(number, null)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    subnets = optional(map(object({
      address_prefix   = optional(string)
      address_prefixes = optional(list(string))
      name             = string
      nat_gateway = optional(object({
        id = string
      }))
      network_security_group = optional(object({
        id = string
      }))
      private_endpoint_network_policies             = optional(string, "Enabled")
      private_link_service_network_policies_enabled = optional(bool, true)
      route_table = optional(object({
        id = string
      }))
      service_endpoint_policies = optional(map(object({
        id = string
      })))
      service_endpoints               = optional(set(string))
      default_outbound_access_enabled = optional(bool, false)
      sharing_scope                   = optional(string, null)
      delegation = optional(list(object({
        name = string
        service_delegation = object({
          name = string
        })
      })))
      timeouts = optional(object({
        create = optional(string)
        delete = optional(string)
        read   = optional(string)
        update = optional(string)
      }))
      role_assignments = optional(map(object({
        role_definition_id_or_name             = string
        principal_id                           = string
        description                            = optional(string, null)
        skip_service_principal_aad_check       = optional(bool, false)
        condition                              = optional(string, null)
        condition_version                      = optional(string, null)
        delegated_managed_identity_resource_id = optional(string, null)
        principal_type                         = optional(string, null)
      })))
    })), {})
    tags = optional(map(string), null)
  })
  description = "(Required) The configuration for the management virtual network. This is a map of key-value pairs."
}

variable "virtual_hub_id" {
  type        = string
  description = "(Required) The ID of the Virtual Hub to which the management virtual network will be connected."
  default     = null
}
