module "avm-res-network-routetable" {
  for_each         = var.user_route_tables
  source           = "Azure/avm-res-network-routetable/azurerm"
  version          = "0.4.1"
  enable_telemetry = false

  name                = each.value.name
  location            = var.location
  resource_group_name = var.resource_group_name
  routes              = each.value.routes
  tags                = each.value.tags
}