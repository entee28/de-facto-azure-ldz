module "connectivity_er_circuit" {
  for_each = var.er_circuits

  source           = "Azure/avm-res-network-expressroutecircuit/azurerm"
  version          = "0.3.0"
  enable_telemetry = false

  resource_group_name   = local.hub_resource_group_name
  name                  = each.value.name
  diagnostic_settings   = each.value.diagnostic_settings
  service_provider_name = each.value.service_provider_name
  peering_location      = each.value.peering_location
  bandwidth_in_mbps     = each.value.bandwidth_in_mbps
  location              = var.location

  sku = each.value.sku

  peerings = each.value.peerings

  express_route_circuit_authorizations = each.value.express_route_circuit_authorizations
  exr_circuit_tags                     = each.value.exr_circuit_tags

  depends_on = [module.connectivity_resourcegroups]
}
