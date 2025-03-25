resource "azurerm_subnet" "monitor_privatelinkscope_subnet" {
  count                             = var.ampls_deployment_enabled ? 1 : 0
  name                              = coalesce(var.ampls_subnet_name, "snet-ampls-prd-${var.location_code}-001")
  resource_group_name               = var.resource_group_name
  virtual_network_name              = var.hub_vnet_name
  address_prefixes                  = [var.ampls_subnet_address_prefix]
  private_endpoint_network_policies = var.ampls_subnet_private_endpoint_network_policies
  depends_on                        = [module.avm-ptn-hubnetworking]
}

module "monitor-privatelinkscope" {
  count               = var.ampls_deployment_enabled ? 1 : 0
  source              = "./modules/monitor-privatelinkscope"
  name                = coalesce(var.ampls_name, local.default_monitor_privatelinkscope_name)
  resource_group_name = var.resource_group_name
  location            = var.location

  ingestion_access_mode = var.ampls_ingestion_access_mode
  query_access_mode     = var.ampls_query_access_mode
  private_endpoint = {
    private_dns_zone_resource_ids = toset(local.ampls_private_dns_zone_ids)
    subnet_id                     = try(azurerm_subnet.monitor_privatelinkscope_subnet[0].id, null)
  }

  tags       = var.ampls_tags
  depends_on = [module.avm-ptn-network-private-link-private-dns-zones]
}