module "connectivity_sidecar_virtualnetworks" {
  for_each         = var.sidecar_vnets
  source           = "Azure/avm-res-network-virtualnetwork/azurerm"
  version          = "0.8.1"
  enable_telemetry = false

  location            = var.location
  name                = each.value.name
  address_space       = each.value.address_space
  resource_group_name = each.value.resource_group_name

  bgp_community           = each.value.bgp_community
  ddos_protection_plan    = each.value.ddos_protection_plan
  diagnostic_settings     = each.value.diagnostic_settings
  dns_servers             = each.value.dns_servers
  enable_vm_protection    = each.value.enable_vm_protection
  encryption              = each.value.encryption
  flow_timeout_in_minutes = each.value.flow_timeout_in_minutes
  lock                    = each.value.lock
  role_assignments        = each.value.role_assignments
  subnets                 = each.value.subnets
  tags                    = each.value.tags

  depends_on = [
    module.connectivity_resourcegroups
  ]
}
