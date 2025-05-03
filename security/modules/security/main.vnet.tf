module "security_virtualnetwork" {
  source           = "Azure/avm-res-network-virtualnetwork/azurerm"
  version          = "0.8.1"
  enable_telemetry = false

  location            = var.location
  name                = local.security_virtual_network_name
  address_space       = var.virtual_network.address_space
  resource_group_name = module.security_resourcegroup.name

  bgp_community           = var.virtual_network.bgp_community
  ddos_protection_plan    = var.virtual_network.ddos_protection_plan
  diagnostic_settings     = var.virtual_network.diagnostic_settings
  dns_servers             = var.virtual_network.dns_servers
  enable_vm_protection    = var.virtual_network.enable_vm_protection
  encryption              = var.virtual_network.encryption
  flow_timeout_in_minutes = var.virtual_network.flow_timeout_in_minutes
  lock                    = var.virtual_network.lock
  role_assignments        = var.virtual_network.role_assignments
  subnets                 = var.virtual_network.subnets
  tags                    = var.virtual_network.tags

  depends_on = [
    module.security_resourcegroup
  ]
}

module "security_vnet_connection" {
  source  = "Azure/avm-ptn-virtualwan/azurerm//modules/vnet-conn"
  version = "0.11.0"
  count   = var.virtual_hub_id != null ? 1 : 0

  virtual_network_connections = {
    security-vnet = {
      name                      = "conn-security-vnet"
      virtual_hub_id            = var.virtual_hub_id
      remote_virtual_network_id = module.security_virtualnetwork.resource_id
      internet_security_enabled = true
    }
  }

  depends_on = [
    module.security_virtualnetwork
  ]
}
