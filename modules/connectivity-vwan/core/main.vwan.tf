module "connectivity-virtual-wan" {
  source           = "Azure/avm-ptn-alz-connectivity-virtual-wan/azurerm"
  version          = "0.2.0"
  enable_telemetry = false

  virtual_hubs = {
    vhub = {
      hub = merge(var.virtual_hub, {
        name           = local.virtual_hub_name
        resource_group = local.resource_group_name
        location       = var.location
      })

      firewall = try(var.firewall, null) != null ? merge(var.firewall, {
        name = local.firewall_name
      }) : null

      firewall_policy = try(var.firewall_policy, null) != null ? merge(var.firewall_policy, {
        name = local.firewall_policy_name
      }) : null

      private_dns_zones = try(var.private_dns_zones, null) != null ? merge(var.private_dns_zones, {
        resource_group_name = local.shared_services_rg_name
        is_primary          = true
        subnet_name         = local.dns_resolver_subnet_name
        private_dns_resolver = {
          name                = local.dns_resolver_name
          resource_group_name = local.shared_services_rg_name
        }
      }) : null

      virtual_network_gateways = {
        vpn = try(var.vpn_gateway, null) != null ? merge(var.vpn_gateway, {
          name = local.vpn_gateway_name
        }) : null
        express_route = try(var.express_route_gateway, null) != null ? merge(var.express_route_gateway, {
          name = local.express_route_gateway_name
        }) : null
      }

      side_car_virtual_network = merge(var.side_car_virtual_network, {
        name = local.shared_vnet_name
      })
    }
  }

  virtual_wan_settings = {
    allow_branch_to_branch_traffic = true
    disable_vpn_encryption         = false
    er_circuit_connections = try(var.er_circuit_connections, null) != null ? {
      for key, conn in var.er_circuit_connections : key => {
        name                                 = conn.name
        authorization_key                    = conn.authorization_key
        enable_internet_security             = conn.enable_internet_security
        express_route_gateway_bypass_enabled = conn.express_route_gateway_bypass_enabled
        routing                              = conn.routing
        routing_weight                       = conn.routing_weight
        express_route_gateway_key            = "vhub"
        express_route_circuit_peering_id     = module.vwan_er_circuit[conn.peering.circuit_name].peerings[conn.peering.peering_name].id
      }
    } : {}
    location            = var.location
    resource_group_name = local.resource_group_name
    name                = local.virtual_wan_name
    type                = "Standard"
    virtual_wan_tags    = var.virtual_wan_tags
    vpn_sites = try(var.vpn_sites, null) != null ? {
      for key, site in var.vpn_sites : key => merge(site, {
        virtual_hub_key = "vhub"
      })
    } : {}

    vpn_site_connections = try(var.vpn_site_connections, null) != null ? {
      for key, conn in var.vpn_site_connections : key => merge(conn, {
        vpn_gateway_key = "vhub"
      })
    } : {}
  }

  depends_on = [module.vwan_resourcegroup, module.vwan_er_circuit]
}
