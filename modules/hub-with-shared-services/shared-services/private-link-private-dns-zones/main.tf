module "avm-ptn-network-private-link-private-dns-zones" {
  source           = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version          = "0.9.0"
  enable_telemetry = false

  location                        = var.location
  resource_group_creation_enabled = true
  resource_group_role_assignments = var.resource_group_role_assignments
  resource_group_name             = local.resource_group_name

  virtual_network_resource_ids_to_link_to = {
    hub = {
      vnet_resource_id = var.shared_services_vnet_resource_id
    }
  }

  tags = var.tags
}
