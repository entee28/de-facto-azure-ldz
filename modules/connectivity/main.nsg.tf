module "avm-res-network-networksecuritygroup" {
  for_each         = var.user_network_security_groups
  source           = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version          = "0.4.0"
  enable_telemetry = false

  location            = var.location
  resource_group_name = var.resource_group_name
  name                = each.value.name

  diagnostic_settings = each.value.diagnostic_settings
  security_rules      = each.value.security_rules
  tags                = each.value.tags
}