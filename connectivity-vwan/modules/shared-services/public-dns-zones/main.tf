module "avm-res-network-dnszone" {
  source           = "Azure/avm-res-network-dnszone/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  for_each = var.public_dns_zones

  name                = each.value.name
  resource_group_name = local.resource_group_name

  a_records     = each.value.a_records
  aaaa_records  = each.value.aaaa_records
  cname_records = each.value.cname_records
  mx_records    = each.value.mx_records
  ns_records    = each.value.ns_records
  ptr_records   = each.value.ptr_records
  srv_records   = each.value.srv_records
  txt_records   = each.value.txt_records

  tags = merge(var.tags, each.value.tags)
}
