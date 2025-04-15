variable "virtual_wan_name" {
  type        = string
  description = "(Optional) Name of the Virtual WAN resource. If not provided, a default name will be generated."
  default     = null
}

variable "virtual_wan_tags" {
  type        = map(string)
  description = "(Optional) Tags to apply to the Virtual WAN resource."
  default     = {}
}

variable "virtual_hub" {
  type = object({
    address_prefix     = string
    name               = optional(string)
    routing_preference = optional(string, "ExpressRoute")
    tags               = optional(map(string))
  })
  description = "Configuration for the Virtual Hub. Contains name, address_prefix, optional routing_preference (defaults to ExpressRoute), and optional tags."
}

variable "firewall" {
  type = object({
    sku_name             = optional(string, "AZFW_Hub")
    sku_tier             = string
    name                 = optional(string)
    zones                = optional(list(number), [1, 2, 3])
    firewall_policy_id   = optional(string)
    vhub_public_ip_count = optional(string)
    tags                 = optional(map(string))
  })
  description = "Configuration for the Firewall."
  default     = null
}

variable "express_route_gateway" {
  type = object({
    name                          = optional(string)
    tags                          = optional(map(string))
    allow_non_virtual_wan_traffic = optional(bool, false)
    scale_units                   = optional(number, 1)
  })
  description = "Configuration for ExpressRoute Gateway. Contains name, virtual_hub_key, optional sku (defaults to Standard), address_prefix, routing_preference (defaults to ExpressRoute), and optional tags."
  default     = null
}

variable "vpn_gateway" {
  type = object({
    name                                  = optional(string)
    tags                                  = optional(map(string))
    bgp_route_translation_for_nat_enabled = optional(bool)
    bgp_settings = optional(object({
      instance_0_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      instance_1_bgp_peering_address = optional(object({
        custom_ips = list(string)
      }))
      peer_weight = number
      asn         = number
    }))
    routing_preference = optional(string)
    scale_unit         = optional(number)
  })
  description = "Configuration for VPN Gateway. Contains name, virtual_hub_key, optional sku (defaults to Standard), address_prefix, routing_preference (defaults to ExpressRoute), and optional tags."
  default     = null
}

variable "vpn_sites" {
  type = map(object({
    name = string
    links = list(object({
      name = string
      bgp = optional(object({
        asn             = number
        peering_address = string
      }))
      fqdn          = optional(string)
      ip_address    = optional(string)
      provider_name = optional(string)
      speed_in_mbps = optional(number)
      }
    ))
    address_cidrs = optional(list(string))
    device_model  = optional(string)
    device_vendor = optional(string)
    o365_policy = optional(object({
      traffic_category = object({
        allow_endpoint_enabled    = optional(bool)
        default_endpoint_enabled  = optional(bool)
        optimize_endpoint_enabled = optional(bool)
      })
    }))
    tags = optional(map(string))
  }))
  description = "Map of objects for VPN Sites to deploy into the Virtual WAN Virtual Hubs"
  default     = null
}

variable "vpn_site_connections" {
  type = map(object({
    name                = string
    remote_vpn_site_key = string
    vpn_links = list(object({
      name                                  = string
      bandwidth_mbps                        = optional(number)
      bgp_enabled                           = optional(bool)
      local_azure_ip_address_enabled        = optional(bool)
      policy_based_traffic_selector_enabled = optional(bool)
      ratelimit_enabled                     = optional(bool)
      route_weight                          = optional(number)
      shared_key                            = optional(string)
      vpn_site_link_number                  = optional(number)
    }))
  }))
  description = "Map of objects for VPN Site Connections to deploy into the Virtual WAN Virtual Hubs"
  default     = null
}

variable "er_circuit_connections" {
  type = map(object({
    name = string
    peering = object({
      circuit_name = string
      peering_name = string
    })
    authorization_key                    = optional(string)
    enable_internet_security             = optional(bool)
    express_route_gateway_bypass_enabled = optional(bool)
    routing = optional(object({
      associated_route_table_id = string
      propagated_route_table = optional(object({
        route_table_ids = optional(list(string))
        labels          = optional(list(string))
      }))
      inbound_route_map_id  = optional(string)
      outbound_route_map_id = optional(string)
    }))
    routing_weight = optional(number)
  }))
  description = "Map of objects for ExpressRoute Circuit connections to connect to the Virtual WAN ExpressRoute Gateways."
  default     = null
}
