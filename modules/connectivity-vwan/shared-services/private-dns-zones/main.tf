module "avm-res-network-privatednszone" {
  source           = "Azure/avm-res-network-privatednszone/azurerm"
  version          = "0.3.0"
  enable_telemetry = false

  for_each = var.private_dns_zones

  domain_name         = each.value.domain_name
  resource_group_name = local.resource_group_name

  virtual_network_links = {
    shared_vnet_link = {
      virtual_network_id   = local.virtual_network_resource_id
      registration_enabled = each.value.vnet_link_registration_enabled
    }
  }

  a_records     = each.value.a_records
  aaaa_records  = each.value.aaaa_records
  cname_records = each.value.cname_records
  mx_records    = each.value.mx_records
  srv_records   = each.value.srv_records
  txt_records   = each.value.txt_records
  tags          = merge(var.tags, each.value.tags)
}
