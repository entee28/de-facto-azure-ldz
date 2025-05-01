locals {
  location_code = local.get_region_code[var.location]
  environment   = "prd"
  name_suffix   = format("connectivity-%s-%s", local.environment, local.location_code)

  default_hub_resource_group_name = format("rg-%s-platform-%s-001", var.company_name, local.name_suffix)
  default_virtual_wan_name        = format("vwan-platform-%s-001", local.name_suffix)
  default_virtual_hub_name        = format("vhub-platform-%s-001", local.name_suffix)
  default_vpn_gateway_name        = format("vgw-%s-001", local.name_suffix)
  default_er_gateway_name         = format("ergw-%s-001", local.name_suffix)
  default_firewall_name           = format("fw-%s-001", local.name_suffix)
  default_firewall_policy_name    = format("fwp-%s-001", local.name_suffix)


  hub_resource_group_name    = coalesce(var.hub_resource_group_name, local.default_hub_resource_group_name)
  virtual_wan_name           = coalesce(var.virtual_wan_name, local.default_virtual_wan_name)
  virtual_hub_name           = coalesce(try(var.virtual_hub.name, null), local.default_virtual_hub_name)
  express_route_gateway_name = coalesce(try(var.express_route_gateway.name, null), local.default_er_gateway_name)
  vpn_gateway_name           = coalesce(try(var.vpn_gateway.name, null), local.default_vpn_gateway_name)
  firewall_name              = coalesce(try(var.firewall.name, null), local.default_firewall_name)
  firewall_policy_name       = coalesce(try(var.firewall_policy.name, null), local.default_firewall_policy_name)

  # Merge hub and sidecar resource groups
  resource_groups = merge(
    # Hub resource group (always created)
    {
      (local.hub_resource_group_name) = {
        name             = local.hub_resource_group_name
        tags             = var.hub_resource_group_tags
        lock             = null
        role_assignments = {}
      }
    },
    # Optional sidecar resource groups
    var.connectivity_sidecar_resourcegroups
  )
}
