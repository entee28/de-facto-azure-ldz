module "management_virtualnetwork" {
  source           = "Azure/avm-res-network-virtualnetwork/azurerm"
  version          = "0.8.1"
  enable_telemetry = false

  location            = var.location
  name                = local.management_virtual_network_name
  address_space       = var.management_virtual_network.address_space
  resource_group_name = module.management_resourcegroup.name

  bgp_community           = var.management_virtual_network.bgp_community
  ddos_protection_plan    = var.management_virtual_network.ddos_protection_plan
  diagnostic_settings     = var.management_virtual_network.diagnostic_settings
  dns_servers             = var.management_virtual_network.dns_servers
  enable_vm_protection    = var.management_virtual_network.enable_vm_protection
  encryption              = var.management_virtual_network.encryption
  flow_timeout_in_minutes = var.management_virtual_network.flow_timeout_in_minutes
  lock                    = var.management_virtual_network.lock
  role_assignments        = var.management_virtual_network.role_assignments
  subnets                 = var.management_virtual_network.subnets
  tags                    = var.management_virtual_network.tags

  depends_on = [
    module.management_resourcegroup
  ]
}

module "management_vnet_connection" {
  source  = "Azure/avm-ptn-virtualwan/azurerm//modules/vnet-conn"
  version = "0.11.0"
  count   = var.virtual_hub_id != null ? 1 : 0

  virtual_network_connections = {
    management-vnet = {
      name                      = "conn-management-vnet"
      virtual_hub_id            = var.virtual_hub_id
      remote_virtual_network_id = module.management_virtualnetwork.resource_id
      internet_security_enabled = true
    }
  }

  depends_on = [
    module.management_virtualnetwork
  ]
}
