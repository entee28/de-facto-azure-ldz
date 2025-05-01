module "avm-res-network-privatednszone" {
  source           = "Azure/avm-res-network-privatednszone/azurerm"
  version          = "0.3.0"
  enable_telemetry = false

  for_each = var.private_dns_zones

  domain_name         = each.value.domain_name
  resource_group_name = local.resource_group_name

  virtual_network_links = {
    shared_vnet_link = {
      vnetlinkname     = "shared-vnet-link"
      vnetid           = local.virtual_network_resource_id
      autoregistration = each.value.vnet_link_autoregistration
    }
  }

  a_records = {
    for k, v in each.value.a_records : k => {
      name                = v.name
      ttl                 = v.ttl
      records             = v.records
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  aaaa_records = {
    for k, v in each.value.aaaa_records : k => {
      name                = v.name
      ttl                 = v.ttl
      records             = v.records
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  cname_records = {
    for k, v in each.value.cname_records : k => {
      name                = v.name
      ttl                 = v.ttl
      record              = v.record
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  mx_records = {
    for k, v in each.value.mx_records : k => {
      name                = v.name
      ttl                 = v.ttl
      records             = v.records
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  srv_records = {
    for k, v in each.value.srv_records : k => {
      name                = v.name
      ttl                 = v.ttl
      records             = v.records
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  txt_records = {
    for k, v in each.value.txt_records : k => {
      name = v.name
      ttl  = v.ttl
      records = {
        for i, record in v.records[0] : tostring(i) => {
          value = record
        }
      }
      resource_group_name = local.resource_group_name
      zone_name           = each.value.domain_name
      tags                = v.tags
    }
  }

  tags = merge(var.tags, each.value.tags)
}
