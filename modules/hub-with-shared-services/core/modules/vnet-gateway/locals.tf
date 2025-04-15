locals {
  # Common naming components
  name_suffix = format("connectivity-%s-%s", var.environment, var.location_code)

  # Default resource group name
  default_resource_group_name = format("rg-%s-%s-001", var.company_name, local.name_suffix)

  # Default resource names
  default_vnet_gateway_name = format("vgw-%s-001", local.name_suffix)

  # Resource names
  resource_group_name = coalesce(var.resource_group_name, local.default_resource_group_name)

  # Transform gateway configuration for the AVM module
  gateway_input = {
    name              = coalesce(try(var.gateway_configuration.name, null), local.default_vnet_gateway_name)
    type              = var.gateway_configuration.type
    sku_name          = var.gateway_configuration.sku
    ip_configurations = var.gateway_configuration.ip_configurations
    active_active     = var.gateway_configuration.active_active_enabled
    enable_private_ip = var.gateway_configuration.enable_private_ip

    bgp_settings = var.gateway_configuration.bgp_settings != null ? {
      asn                             = var.gateway_configuration.bgp_settings.asn
      peer_weight                     = var.gateway_configuration.bgp_settings.peer_weight
      peering_addresses_configuration = var.gateway_configuration.bgp_settings.peering_addresses
    } : null

    virtual_wan = null # Not supporting virtual WAN in this implementation

    # VPN specific settings
    vpn_type       = try(var.gateway_configuration.vpn_settings.vpn_type, null)
    vpn_generation = var.gateway_configuration.type == "Vpn" ? var.gateway_configuration.generation : null
    enable_bgp     = var.gateway_configuration.bgp_settings != null

    # Point to site configuration
    point_to_site_configuration = var.point_to_site != null ? {
      address_space            = var.point_to_site.address_space
      vpn_authentication_types = var.point_to_site.vpn_auth_types
      vpn_client_protocols     = var.point_to_site.vpn_client_protocols
      aad_authentication       = var.point_to_site.aad_auth
      radius_servers           = try(var.point_to_site.radius_auth.servers, null)
      client_root_certificates = try(var.point_to_site.certificate_auth.root_certificates, null)
      revoked_certificates     = try(var.point_to_site.certificate_auth.revoked_certificates, null)
    } : null

    # Connection configuration
    vpn_connections = {
      for key, conn in var.connections : key => {
        name                               = coalesce(conn.name, "conn-${key}")
        internet_security_enabled          = true
        shared_key                         = conn.shared_key
        connection_mode                    = conn.connection_mode
        dpd_timeout_seconds                = conn.dpd_timeout_seconds
        egress_nat_rule_ids                = []
        ingress_nat_rule_ids               = []
        local_azure_ip_address_enabled     = conn.local_azure_ip_address_enabled
        peer_virtual_network_gateway_id    = conn.target.resource_id
        routing_weight                     = conn.routing_weight
        use_policy_based_traffic_selectors = conn.type == "IPsec"

        local_network_gateway     = try(conn.target.local_network_gateway, null)
        ipsec_policy              = conn.ipsec_policy
        traffic_selector_policies = conn.traffic_selector_policy
        custom_bgp_addresses      = conn.custom_bgp_addresses

        protocol = conn.connection_protocol
        type     = conn.type
      }
    }
  }
}
