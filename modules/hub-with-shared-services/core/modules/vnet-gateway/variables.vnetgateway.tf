# Gateway Configuration
variable "gateway_configuration" {
  description = "Configuration for the virtual network gateway"
  type = object({
    name = optional(string)
    type = string # "Vpn" or "ExpressRoute"

    # Common settings
    sku                   = string
    active_active_enabled = optional(bool, false)
    enable_private_ip     = optional(bool, false)
    generation            = optional(string) # Required for VPN type, ignored for ExpressRoute

    ip_configurations = map(object({
      name               = optional(string)
      public_ip_enabled  = optional(bool, true)
      public_ip_name     = optional(string)
      public_ip_zones    = optional(list(string))
      private_ip_address = optional(string)
      subnet_id          = optional(string)
    }))

    # VPN specific settings
    vpn_settings = optional(object({
      vpn_type                   = optional(string, "RouteBased")
      dns_forwarding_enabled     = optional(bool, false)
      private_ip_address_enabled = optional(bool, false)
      custom_route = optional(object({
        address_prefixes = list(string)
      }))
      policy_based_traffic_selectors_enabled = optional(bool, false)
    }))

    # ExpressRoute specific settings
    expressroute_settings = optional(object({
      allow_classic_operations = optional(bool, false)
      circuit = optional(object({
        authorization_key = optional(string)
        id                = string
      }))
    }))

    # BGP settings
    bgp_settings = optional(object({
      asn         = number
      peer_weight = optional(number)
      peering_addresses = optional(map(object({
        ip_configuration_name = string
        apipa_addresses       = optional(list(string))
        custom_addresses      = optional(list(string))
      })))
    }))
  })
}

# Connection Configuration
variable "connections" {
  description = "Map of connections to create from the virtual network gateway"
  type = map(object({
    name = optional(string)
    type = string # IPsec, ExpressRoute, Vnet2Vnet

    # Target Resource
    target = object({
      resource_id = optional(string) # For Vnet2Vnet or ExpressRoute connections
      local_network_gateway = optional(object({
        name            = optional(string)
        address_space   = list(string)
        gateway_address = string
        gateway_fqdn    = optional(string)
        bgp_settings = optional(object({
          asn                 = number
          bgp_peering_address = string
          peer_weight         = optional(number)
        }))
      }))
    })

    # Connection Settings
    shared_key                     = optional(string)
    connection_mode                = optional(string)
    dpd_timeout_seconds            = optional(number)
    connection_protocol            = optional(string)
    enable_bgp                     = optional(bool)
    express_route_gateway_bypass   = optional(bool)
    routing_weight                 = optional(number)
    local_azure_ip_address_enabled = optional(bool)

    # IPsec Policy
    ipsec_policy = optional(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string
      sa_lifetime      = optional(number)
      sa_datasize      = optional(number)
    }))

    # Traffic Selector Policy
    traffic_selector_policy = optional(list(object({
      local_address_prefixes  = list(string)
      remote_address_prefixes = list(string)
    })))

    # Custom BGP addresses
    custom_bgp_addresses = optional(object({
      primary   = string
      secondary = string
    }))

    tags = optional(map(string))
  }))
  default = {}
}

# P2S Configuration
variable "point_to_site" {
  description = "Point to site VPN configuration"
  type = object({
    address_space = list(string)

    # Authentication Types
    aad_auth = optional(object({
      audience = string
      issuer   = string
      tenant   = string
    }))

    radius_auth = optional(object({
      servers = map(object({
        address = string
        secret  = string
        score   = optional(number)
      }))
    }))

    certificate_auth = optional(object({
      root_certificates = optional(map(object({
        name             = string
        public_cert_data = string
      })))
      revoked_certificates = optional(map(object({
        name       = string
        thumbprint = string
      })))
    }))

    # Client Configuration
    vpn_client_protocols = optional(list(string))
    vpn_auth_types       = optional(list(string))

    # IPsec/IKE policy
    ipsec_policy = optional(object({
      dh_group         = string
      ike_encryption   = string
      ike_integrity    = string
      ipsec_encryption = string
      ipsec_integrity  = string
      pfs_group        = string
      sa_lifetime      = optional(number)
      sa_datasize      = optional(number)
    }))
  })
  default = null
}

# Resource Configuration
variable "virtual_network_id" {
  description = "The ID of the virtual network where the gateway will be created"
  type        = string
}

variable "subnet_address_prefix" {
  description = "The address prefix for the gateway subnet"
  type        = string
}

variable "route_table_creation_enabled" {
  description = "Enable creation of a route table for the gateway subnet"
  type        = bool
  default     = true
}

variable "route_table_name" {
  description = "Name of the route table to create for the gateway subnet"
  type        = string
  default     = null
}