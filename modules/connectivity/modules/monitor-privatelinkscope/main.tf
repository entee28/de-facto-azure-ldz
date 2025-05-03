terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}
data "azurerm_resource_group" "parent" {
  count = var.location == null ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_monitor_private_link_scope" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name

  ingestion_access_mode = var.ingestion_access_mode
  query_access_mode     = var.query_access_mode

  tags = var.tags
  lifecycle { ignore_changes = [tags["created_date"]] }
}

resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azurerm_monitor_private_link_scope.this.id
  lock_level = var.lock.kind
}

module "privateendpoint" {
  for_each         = var.private_endpoint
  source           = "Azure/avm-res-network-privateendpoint/azurerm"
  version          = "0.2.0"
  enable_telemetry = false

  name                = coalesce(each.value.name, "pe-${var.name}")
  location            = coalesce(var.location, local.resource_group_location)
  resource_group_name = var.resource_group_name

  network_interface_name         = each.value.network_interface_name
  private_connection_resource_id = azurerm_monitor_private_link_scope.this.id
  subnet_resource_id             = each.value.subnet_id
  private_dns_zone_group_name    = each.value.private_dns_zone_group_name
  private_dns_zone_resource_ids  = each.value.private_dns_zone_resource_ids
  subresource_names              = ["azuremonitor"]

  tags = var.tags
}
