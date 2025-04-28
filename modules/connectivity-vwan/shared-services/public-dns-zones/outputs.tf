# Resource Group outputs
output "resource_group" {
  description = "The resource group where public DNS zones are created"
  value = {
    name = module.avm-res-resource-group.name
    id   = module.avm-res-resource-group.resource_id
  }
}

# Public DNS Zone outputs
output "public_dns_zones" {
  description = "Information about the created public DNS zones"
  value = {
    for key, zone in module.avm-res-network-dnszone : key => {
      id                    = zone.resource_id
      name_servers          = zone.name_servers
      number_of_record_sets = zone.number_of_record_sets
      records = {
        a_records     = zone.a_record_outputs
        aaaa_records = zone.aaaa_record_outputs
        cname_records = zone.cname_record_outputs
        mx_records    = zone.mx_record_outputs
        ns_records    = zone.ns_record_outputs
        ptr_records   = zone.ptr_record_outputs
        srv_records   = zone.srv_record_outputs
        txt_records   = zone.txt_record_outputs
      }
    }
  }
}

# Summary output
output "dns_zone_name_servers" {
  description = "Map of DNS zone names to their name servers for easy reference"
  value = {
    for key, zone in module.avm-res-network-dnszone : zone.resource.name => zone.resource.name_servers
  }
}

output "dns_zone_resource_ids" {
  description = "Map of DNS zone names to their resource IDs"
  value = {
    for key, zone in module.avm-res-network-dnszone : zone.resource.name => zone.resource.id
  }
}
