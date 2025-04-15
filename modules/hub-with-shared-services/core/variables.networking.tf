# Input variable for virtual networks
variable "virtual_networks" {
  type = map(object({
    name                            = string
    address_space                   = list(string)
    location                        = string
    resource_group_name             = string
    route_table_name_user_subnets   = optional(string)
    route_table_name_firewall       = optional(string)
    bgp_community                   = optional(string)
    ddos_protection_plan_id         = optional(string)
    dns_servers                     = optional(list(string))
    flow_timeout_in_minutes         = optional(number, 4)
    mesh_peering_enabled            = optional(bool, true)
    resource_group_creation_enabled = optional(bool, true)
    resource_group_lock_enabled     = optional(bool, true)
    resource_group_lock_name        = optional(string)
    resource_group_tags             = optional(map(string))
    routing_address_space           = optional(list(string), [])
    hub_router_ip_address           = optional(string)
    tags                            = optional(map(string), {})

    route_table_entries_user_subnets = optional(list(object({
      name                = string
      address_prefix      = string
      next_hop_type       = string
      has_bgp_override    = optional(bool, false)
      next_hop_ip_address = optional(string)
    })), [])

    subnets = optional(map(object({
      name             = string
      address_prefixes = list(string)
      nat_gateway = optional(object({
        id = string
      }))
      network_security_group = optional(object({
        id = string
      }))
      private_endpoint_network_policies_enabled     = optional(bool, true)
      private_link_service_network_policies_enabled = optional(bool, true)
      route_table = optional(object({
        id                           = optional(string)
        assign_generated_route_table = optional(bool, true)
      }))
      service_endpoints           = optional(list(string), [])
      service_endpoint_policy_ids = optional(list(string), [])
      delegations = optional(list(object({
        name = string
        service_delegation = object({
          name    = string
          actions = optional(list(string))
        })
      })), [])
      default_outbound_access_enabled = optional(bool, false)
    })), {})
  }))
  description = "Map of virtual networks to create. Each network can be customized with its own configuration."
  default     = {}
}
