resource "azurerm_subnet" "bastion_subnet" {
  count                = var.bastion_host_deployment_enabled ? 1 : 0
  address_prefixes     = [var.bastion_host_subnet_address_prefix]
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.hub_vnet_name
  depends_on           = [module.avm-ptn-hubnetworking]
}

module "avm-res-network-bastionhost" {
  count            = var.bastion_host_deployment_enabled ? 1 : 0
  source           = "Azure/avm-res-network-bastionhost/azurerm"
  version          = "0.6.0"
  enable_telemetry = false


  name                = coalesce(var.bastion_host_name, local.default_bastion_host_name)
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.bastion_host_sku
  scale_units         = var.bastion_host_scale_units
  zones               = var.bastion_host_zones


  copy_paste_enabled        = var.bastion_host_copy_paste_enabled
  file_copy_enabled         = var.bastion_host_file_copy_enabled
  ip_connect_enabled        = var.bastion_host_ip_connect_enabled
  kerberos_enabled          = var.bastion_host_kerberos_enabled
  session_recording_enabled = var.bastion_host_session_recording_enabled
  shareable_link_enabled    = var.bastion_host_sharable_recording_enabled
  tunneling_enabled         = var.bastion_host_tunneling_enabled

  ip_configuration = {
    name             = "bastion-ipconfig"
    subnet_id        = try(azurerm_subnet.bastion_subnet[0].id, null)
    create_public_ip = true
  }

  diagnostic_settings = var.bastion_host_diagnostic_settings
  role_assignments    = var.bastion_host_role_assignments

  tags       = var.bastion_host_tags
  depends_on = [module.avm-ptn-hubnetworking]
}