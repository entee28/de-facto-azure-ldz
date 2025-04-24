locals {
  location_code               = local.get_region_code[var.location]
  environment                 = "prd"
  connectivity_name_suffix    = format("connectivity-%s-%s", local.environment, local.location_code)
  shared_services_name_suffix = format("shared-%s-%s", local.environment, local.location_code)

  default_resource_group_name  = format("rg-%s-platform-%s-001", var.company_name, local.connectivity_name_suffix)
  default_virtual_wan_name     = format("vwan-platform-%s-001", local.connectivity_name_suffix)
  default_virtual_hub_name     = format("vhub-platform-%s-001", local.connectivity_name_suffix)
  default_vpn_gateway_name     = format("vgw-%s-001", local.connectivity_name_suffix)
  default_er_gateway_name      = format("ergw-%s-001", local.connectivity_name_suffix)
  default_firewall_name        = format("fw-%s-001", local.connectivity_name_suffix)
  default_firewall_policy_name = format("fwp-%s-001", local.connectivity_name_suffix)


  default_shared_services_rg       = format("rg-%s-platform-%s-001", var.company_name, local.shared_services_name_suffix)
  default_dns_resolver_subnet_name = format("snet-dnspr-%s-%s-001", local.environment, local.location_code)
  default_dns_resolver_name        = format("dnspr-%s-001", local.shared_services_name_suffix)
  default_shared_vnet_name         = format("vnet-platform-%s-001", local.shared_services_name_suffix)

  resource_group_name        = coalesce(var.resource_group_name, local.default_resource_group_name)
  virtual_wan_name           = coalesce(var.virtual_wan_name, local.default_virtual_wan_name)
  virtual_hub_name           = coalesce(var.virtual_hub.name, local.default_virtual_hub_name)
  express_route_gateway_name = coalesce(var.express_route_gateway.name, local.default_er_gateway_name)
  vpn_gateway_name           = coalesce(var.vpn_gateway.name, local.default_vpn_gateway_name)
  firewall_name              = coalesce(var.firewall.name, local.default_firewall_name)
  firewall_policy_name       = coalesce(var.firewall_policy.name, local.default_firewall_policy_name)

  shared_services_rg_name  = coalesce(var.shared_services_resource_group_name, local.default_shared_services_rg)
  dns_resolver_subnet_name = coalesce(var.private_dns_zones.subnet_name, local.default_dns_resolver_subnet_name)
  dns_resolver_name        = coalesce(var.private_dns_zones.private_dns_resolver.name, local.default_dns_resolver_name)
  shared_vnet_name         = coalesce(var.side_car_virtual_network.name, local.default_shared_vnet_name)
}
