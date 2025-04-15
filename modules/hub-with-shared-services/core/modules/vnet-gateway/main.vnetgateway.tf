# Configure Virtual Network Gateway
module "avm-ptn-vnetgateway" {
  source           = "Azure/avm-ptn-vnetgateway/azurerm"
  version          = "0.6.3"
  enable_telemetry = false

  location = var.location
  name     = local.gateway_input.name

  type                  = local.gateway_input.type
  sku                   = local.gateway_input.sku_name
  virtual_network_id    = var.virtual_network_id
  subnet_address_prefix = var.subnet_address_prefix

  ip_configurations = {
    for key, config in local.gateway_input.ip_configurations : key => {
      name = config.name
      public_ip = config.public_ip_enabled ? {
        name  = coalesce(config.public_ip_name, format("pip-%s-%s", local.default_vnet_gateway_name, key))
        zones = config.public_ip_zones
      } : null
    }
  }

  # VPN Configuration
  vpn_type                       = try(local.gateway_input.vpn_settings.vpn_type, "RouteBased")
  vpn_generation                 = local.gateway_input.generation
  vpn_active_active_enabled      = local.gateway_input.active_active
  vpn_private_ip_address_enabled = try(local.gateway_input.vpn_settings.private_ip_address_enabled, false)
  vpn_dns_forwarding_enabled     = try(local.gateway_input.vpn_settings.dns_forwarding_enabled, false)
  vpn_custom_route               = try(local.gateway_input.vpn_settings.custom_route, null)

  # VPN Connections
  local_network_gateways = {
    for key, conn in local.gateway_input.vpn_connections : key => {
      name            = conn.local_network_gateway.name
      address_space   = conn.local_network_gateway.address_space
      gateway_address = conn.local_network_gateway.gateway_address
      gateway_fqdn    = conn.local_network_gateway.gateway_fqdn

      connection = {
        name                               = conn.name
        type                               = conn.type
        shared_key                         = conn.shared_key
        enable_bgp                         = conn.enable_bgp
        connection_mode                    = conn.connection_mode
        dpd_timeout_seconds                = conn.dpd_timeout_seconds
        connection_protocol                = conn.connection_protocol
        local_azure_ip_address_enabled     = conn.local_azure_ip_address_enabled
        routing_weight                     = conn.routing_weight
        ipsec_policy                       = conn.ipsec_policy
        traffic_selector_policy            = conn.traffic_selector_policy
        use_policy_based_traffic_selectors = conn.type == "IPsec"
      }
    }
  }

  # P2S Configuration
  vpn_point_to_site = local.gateway_input.point_to_site_configuration

  # Route Table Configuration
  route_table_creation_enabled = var.route_table_creation_enabled
  route_table_name             = coalesce(var.route_table_name, format("rt-%s", local.default_vnet_gateway_name))

  tags = var.tags
}
