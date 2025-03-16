module "avm-ptn-network-private-link-private-dns-zones" {
  source           = "Azure/avm-ptn-network-private-link-private-dns-zones/azurerm"
  version          = "0.9.0"
  enable_telemetry = false

  location                        = var.location
  resource_group_creation_enabled = var.private_dns_zones_resource_group_name != null
  resource_group_role_assignments = var.private_dns_zones_resource_group_role_assignments
  resource_group_name             = coalesce(var.private_dns_zones_resource_group_name, local.default_resource_group_name)

  virtual_network_resource_ids_to_link_to = local.hubnetworking_output_vnet_id

  depends_on = [module.avm-ptn-hubnetworking]
}
