variable "sidecar_vnets" {
  type = map(object({
    name                = string
    address_space       = set(string)
    resource_group_name = string

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
  }))

  default     = {}
  description = "(Optional) A map of sidecar virtual networks to be created. Each key is the name of the virtual network, and the value is an object containing the properties of the virtual network."
  validation {
    condition = alltrue([
      for vnet in values(var.sidecar_vnets) : (
        length(vnet.name) > 0 &&
        length(vnet.address_space) > 0 &&
        length(vnet.resource_group_name) > 0
      )
    ])
    error_message = "Each sidecar virtual network must have a name, address space, and resource group name."
  }
  validation {
    condition = alltrue([
      for vnet in values(var.sidecar_vnets) : (
        length(vnet.address_space) > 0 &&
        alltrue([
          for prefix in vnet.address_space : (
            can(cidrhost(prefix, 0)) &&
            can(cidrsubnet(prefix, 0, 0))
          )
        ])
      )
    ])
    error_message = "Each address space must be a valid CIDR block."
  }
}
