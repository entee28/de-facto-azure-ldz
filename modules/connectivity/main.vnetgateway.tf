module "avm-ptn-vnetgateway" {
  source           = "Azure/avm-ptn-vnetgateway/azurerm"
  version          = "0.6.3"
  enable_telemetry = false

  location = var.location
  name     = coalesce(var.vnetgateway_name, local.default_vnet_gateway_name)

  type                      = "Vpn"
  vpn_active_active_enabled = var.vnetgateway_vpn_active_active_enabled
  vpn_generation            = var.vnetgateway_vpn_generation
  sku                       = var.vnetgateway_sku
  vpn_type                  = var.vnetgateway_vpn_type

  virtual_network_id    = local.hubnetworking_output_vnet_id
  subnet_address_prefix = var.vnetgateway_subnet_address_prefix


  ip_configurations = {
    default = {
      name = "default"
      public_ip = {
        name  = "pip-${local.default_vnet_gateway_name}"
        zones = var.vnetgateway_vpn_public_ip_zones
      }
    }
  }

  local_network_gateways = var.vnetgateway_local_network_gateways
  vpn_point_to_site      = var.vnetgateway_vpn_point_to_site

  vpn_private_ip_address_enabled = var.vnetgateway_vpn_private_ip_address_enabled
  vpn_dns_forwarding_enabled     = var.vnetgateway_vpn_dns_forwarding_enabled
  vpn_custom_route               = var.vnetgateway_vpn_custom_route

  route_table_creation_enabled = true
  route_table_name             = "rt-vnet-gateway"

  tags = var.vnetgateway_tags

  depends_on = [module.avm-ptn-hubnetworking]
}
