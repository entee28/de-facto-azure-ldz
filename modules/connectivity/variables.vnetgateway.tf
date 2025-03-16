variable "vnetgateway_name" {
  description = "The name of the virtual network gateway."
  type        = string
  default     = null
}

variable "vnetgateway_sku" {
  description = "The SKU of the virtual network gateway."
  type        = string
  default     = "VpnGw1AZ"
}

variable "vnetgateway_vpn_active_active_enabled" {
  description = "Enable active-active mode for the VPN gateway."
  type        = bool
  default     = false
}

variable "vnetgateway_subnet_address_prefix" {
  description = "The address prefix of the virtual network gateway subnet."
  type        = string
}

variable "vnetgateway_vpn_generation" {
  description = "The generation of the VPN gateway."
  type        = string
  default     = "Generation1"
}

variable "vnetgateway_vpn_type" {
  description = "The type of the VPN gateway."
  type        = string
  default     = "RouteBased"
}

variable "vnetgateway_vpn_private_ip_address_enabled" {
  description = "Enable private IP address for the VPN gateway."
  type        = bool
  default     = null
}

variable "vnetgateway_vpn_public_ip_zones" {
  description = "Enable private IP address for the VPN gateway."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "vnetgateway_vpn_dns_forwarding_enabled" {
  description = "Enable DNS forwarding for the VPN gateway."
  type        = bool
  default     = null
}

variable "vnetgateway_vpn_custom_route" {
  description = "The custom route for the VPN gateway."
  type = object({
    address_prefixes = list(string)
  })
  default = null
}

variable "vnetgateway_tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vnetgateway_local_network_gateways" {
  description = "The local network gateways to connect to the virtual network gateway."
  type = map(object({
    id                  = optional(string, null)
    name                = optional(string, null)
    resource_group_name = optional(string, null)
    address_space       = optional(list(string), null)
    gateway_fqdn        = optional(string, null)
    gateway_address     = optional(string, null)
    tags                = optional(map(string), {})
    bgp_settings = optional(object({
      asn                 = number
      bgp_peering_address = string
      peer_weight         = optional(number, null)
    }), null)
    connection = optional(object({
      name                               = optional(string, null)
      resource_group_name                = optional(string, null)
      type                               = string
      connection_mode                    = optional(string, null)
      connection_protocol                = optional(string, null)
      dpd_timeout_seconds                = optional(number, null)
      egress_nat_rule_ids                = optional(list(string), null)
      enable_bgp                         = optional(bool, null)
      ingress_nat_rule_ids               = optional(list(string), null)
      local_azure_ip_address_enabled     = optional(bool, null)
      peer_virtual_network_gateway_id    = optional(string, null)
      routing_weight                     = optional(number, null)
      shared_key                         = optional(string, null)
      tags                               = optional(map(string), null)
      use_policy_based_traffic_selectors = optional(bool, null)
      custom_bgp_addresses = optional(object({
        primary   = string
        secondary = string
      }), null)
      ipsec_policy = optional(object({
        dh_group         = string
        ike_encryption   = string
        ike_integrity    = string
        ipsec_encryption = string
        ipsec_integrity  = string
        pfs_group        = string
        sa_datasize      = optional(number, null)
        sa_lifetime      = optional(number, null)
      }), null)
      traffic_selector_policy = optional(list(
        object({
          local_address_prefixes  = list(string)
          remote_address_prefixes = list(string)
        })
      ), null)
    }), null)
  }))
  default = {}
}

variable "vnetgateway_vpn_point_to_site" {
  description = "The VPN point-to-site configuration."
  type = object({
    address_space         = list(string)
    aad_tenant            = optional(string, null)
    aad_audience          = optional(string, null)
    aad_issuer            = optional(string, null)
    radius_server_address = optional(string, null)
    radius_server_secret  = optional(string, null)
    root_certificates = optional(map(object({
      name             = string
      public_cert_data = string
    })), {})
    revoked_certificates = optional(map(object({
      name       = string
      thumbprint = string
    })), {})
    radius_servers = optional(map(object({
      address = string
      secret  = string
      score   = number
    })), {})
    vpn_client_protocols = optional(list(string), null)
    vpn_auth_types       = optional(list(string), null)
    ipsec_policy = optional(object({
      dh_group                  = string
      ike_encryption            = string
      ike_integrity             = string
      ipsec_encryption          = string
      ipsec_integrity           = string
      pfs_group                 = string
      sa_data_size_in_kilobytes = optional(number, null)
      sa_lifetime_in_seconds    = optional(number, null)
    }), null)
    virtual_network_gateway_client_connections = optional(map(object({
      name               = string
      policy_group_names = list(string)
      address_prefixes   = list(string)
    })), {})
  })
  default = null
}
