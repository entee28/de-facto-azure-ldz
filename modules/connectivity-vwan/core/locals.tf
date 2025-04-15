locals {
  location_code = local.get_region_code[var.location]
  environment   = "prd"
  name_suffix   = format("%s-connectivity-%s-%s", var.company_name, local.location_code, local.environment)

  default_resource_group_name = format("rg-%s", local.name_suffix)
  default_virtual_wan_name    = format("vwan-%s", local.name_suffix)
  default_virtual_hub_name    = format("vhub-%s", local.name_suffix)
  default_vpn_gateway_name    = format("vgw-%s", local.name_suffix)
  default_er_gateway_name     = format("ergw-%s", local.name_suffix)
  default_firewall_name       = format("fw-%s", local.name_suffix)

  resource_group_name        = coalesce(var.resource_group_name, local.default_resource_group_name)
  virtual_wan_name           = coalesce(var.virtual_wan_name, local.default_virtual_wan_name)
  virtual_hub_name           = coalesce(var.virtual_hub.name, local.default_virtual_hub_name)
  express_route_gateway_name = coalesce(var.express_route_gateway.name, local.default_er_gateway_name)
  vpn_gateway_name           = coalesce(var.vpn_gateway.name, local.default_vpn_gateway_name)
  firewall_name              = coalesce(var.firewall.name, local.default_firewall_name)
}
