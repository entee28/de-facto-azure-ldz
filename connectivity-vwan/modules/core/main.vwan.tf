module "vwan_with_vhub" {
  source           = "Azure/avm-ptn-virtualwan/azurerm"
  version          = "0.11.0"
  enable_telemetry = false

  location                       = var.location
  resource_group_name            = local.hub_resource_group_name
  create_resource_group          = false
  virtual_wan_name               = local.virtual_wan_name
  virtual_wan_tags               = var.virtual_wan_tags
  disable_vpn_encryption         = false
  allow_branch_to_branch_traffic = true
  type                           = "Standard"

  virtual_hubs = {
    vhub = merge(var.virtual_hub, {
      name           = local.virtual_hub_name
      resource_group = local.hub_resource_group_name
      location       = var.location
    })
  }

  firewalls = var.firewall != {} ? {
    vhub-fw = merge(var.firewall, {
      name               = local.firewall_name
      virtual_hub_key    = "vhub"
      firewall_policy_id = module.connectivity_firewallpolicy.resource_id
    })
  } : {}

  expressroute_gateways = var.express_route_gateway != null ? {
    vhub-er-gw = merge(var.express_route_gateway, {
      name            = local.express_route_gateway_name
      virtual_hub_key = "vhub"
    })
  } : {}

  er_circuit_connections = var.er_circuit_connections != null ? {
    for key, conn in var.er_circuit_connections : key => {
      name                                 = conn.name
      authorization_key                    = conn.authorization_key
      enable_internet_security             = conn.enable_internet_security
      express_route_gateway_bypass_enabled = conn.express_route_gateway_bypass_enabled
      routing                              = conn.routing
      routing_weight                       = conn.routing_weight
      express_route_gateway_key            = "vhub-er-gw"
      express_route_circuit_peering_id     = module.connectivity_er_circuit[conn.peering.circuit_name].peerings[conn.peering.peering_name].id
    }
  } : {}

  vpn_gateways = var.vpn_gateway != null ? {
    vhub-vpn-gw = merge(var.vpn_gateway, {
      name            = local.vpn_gateway_name
      virtual_hub_key = "vhub"
    })
  } : {}

  vpn_sites = var.vpn_sites != null ? {
    for key, site in var.vpn_sites : key => merge(site, {
      virtual_hub_key = "vhub"
    })
  } : {}

  vpn_site_connections = var.vpn_site_connections != null ? {
    for key, conn in var.vpn_site_connections : key => merge(conn, {
      vpn_gateway_key = "vhub-vpn-gw"
    })
  } : {}

  virtual_network_connections = {
    for k, v in module.connectivity_sidecar_virtualnetworks : k => {
      name                      = "conn-${v.name}"
      virtual_hub_key           = "vhub"
      remote_virtual_network_id = v.resource_id
      internet_security_enabled = false
    }
  }

  depends_on = [
    module.connectivity_resourcegroups,
    module.connectivity_er_circuit,
    module.connectivity_sidecar_virtualnetworks,
    module.connectivity_firewallpolicy
  ]
}
