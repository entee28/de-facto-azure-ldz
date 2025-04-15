# Create resource group for private DNS zones
module "avm-res-resource-group" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  name     = local.resource_group_name
  location = var.location
  tags     = merge(var.tags, var.resource_group_tags)
}

# Create private DNS zones
module "avm-res-network-privatednszone" {
  source           = "Azure/avm-res-network-privatednszone/azurerm"
  version          = "0.3.0"
  enable_telemetry = false

  for_each = var.private_dns_zones

  domain_name         = each.value.domain_name
  resource_group_name = module.avm-res-resource-group.name

  virtual_network_links = {
    for link_key, link in each.value.virtual_network_links : link_key => {
      virtual_network_id   = link.virtual_network_id
      registration_enabled = link.registration_enabled
    }
  }

  a_records     = each.value.a_records
  aaaa_records  = each.value.aaaa_records
  cname_records = each.value.cname_records
  mx_records    = each.value.mx_records
  srv_records   = each.value.srv_records
  txt_records   = each.value.txt_records
  tags          = merge(var.tags, each.value.tags)

  depends_on = [module.avm-res-resource-group]
}
