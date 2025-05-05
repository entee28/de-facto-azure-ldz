variable "er_circuits" {
  type = map(object({
    name                  = string
    peering_location      = string
    service_provider_name = string
    sku = object({
      tier   = string
      family = string
    })
    bandwidth_in_mbps = number
    peerings = optional(map(object({
      peering_type                  = string
      vlan_id                       = number
      primary_peer_address_prefix   = optional(string, null)
      secondary_peer_address_prefix = optional(string, null)
      ipv4_enabled                  = optional(bool, true)
      shared_key                    = optional(string, null)
      peer_asn                      = optional(number, null)
      route_filter_resource_id      = optional(string, null)
      microsoft_peering_config = optional(object({
        advertised_public_prefixes = list(string)
        customer_asn               = optional(number, null)
        routing_registry_name      = optional(string, "NONE")
        advertised_communities     = optional(list(string), null)
      }), null)
      ipv6 = optional(object({
        primary_peer_address_prefix   = string
        secondary_peer_address_prefix = string
        enabled                       = optional(bool, true)
        route_filter_resource_id      = optional(string, null)
        microsoft_peering = optional(object({
          advertised_public_prefixes = optional(list(string))
          customer_asn               = optional(number, null)
          routing_registry_name      = optional(string, "NONE")
          advertised_communities     = optional(list(string), null)
        }), null)
      }))
    })))
    express_route_circuit_authorizations = optional(map(object({
      name = string
    })), {})
    exr_circuit_tags = optional(map(string), null)
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
  }))
  description = "Configuration for ExpressRoute Circuits."
  default     = {}
}
