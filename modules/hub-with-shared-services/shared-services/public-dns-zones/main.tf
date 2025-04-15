# Create resource group for public DNS zones
module "avm-res-resource-group" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  name     = local.resource_group_name
  location = var.location
  tags     = merge(var.tags, var.resource_group_tags)
}

# Create public DNS zones
module "avm-res-network-dnszone" {
  source           = "Azure/avm-res-network-dnszone/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  for_each = var.public_dns_zones

  name                = each.value.name
  resource_group_name = module.avm-res-resource-group.name

  a_records     = each.value.a_records
  aaaa_records  = each.value.aaaa_records
  cname_records = each.value.cname_records
  mx_records    = each.value.mx_records
  ns_records    = each.value.ns_records
  ptr_records   = each.value.ptr_records
  srv_records   = each.value.srv_records
  txt_records   = each.value.txt_records

  tags = merge(var.tags, each.value.tags)

  depends_on = [module.avm-res-resource-group]
}
