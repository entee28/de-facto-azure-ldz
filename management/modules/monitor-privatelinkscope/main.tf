resource "azurerm_monitor_private_link_scope" "this" {
  name                = local.ampls_name
  resource_group_name = local.resource_group_name

  ingestion_access_mode = var.ingestion_access_mode
  query_access_mode     = var.query_access_mode

  tags = var.tags
  lifecycle { ignore_changes = [tags["created_date"]] }
}

resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${local.ampls_name}")
  scope      = azurerm_monitor_private_link_scope.this.id
  lock_level = var.lock.kind
}

module "ampls_privateendpoint" {
  source           = "Azure/avm-res-network-privateendpoint/azurerm"
  version          = "0.2.0"
  enable_telemetry = false

  name                = local.private_endpoint_name
  location            = var.location
  resource_group_name = local.resource_group_name

  private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
  network_interface_name         = local.private_endpoint_network_interface_name
  subnet_resource_id             = var.private_endpoint.subnet_id
  private_dns_zone_group_name    = var.private_endpoint.private_dns_zone_group_name
  private_dns_zone_resource_ids  = local.ampls_private_dns_zone_ids
  subresource_names              = ["azuremonitor"]

  tags = var.tags
}
