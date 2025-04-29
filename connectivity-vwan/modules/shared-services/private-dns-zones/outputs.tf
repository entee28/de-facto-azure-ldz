# Private DNS Zone outputs
output "private_dns_zones" {
  description = "Information about the created private DNS zones"
  value = {
    for key, zone in module.avm-res-network-privatednszone : key => {
      id          = zone.resource.id
      domain_name = zone.resource.name
      resource_id = zone.resource_id
      records = {
        a_records     = zone.a_record_outputs
        aaaa_records = zone.aaaa_record_outputs
        cname_records = zone.cname_record_outputs
        mx_records    = zone.mx_record_outputs
        srv_records   = zone.srv_record_outputs
        txt_records   = zone.txt_record_outputs
      }
      virtual_network_links = zone.virtual_network_link_outputs
    }
  }
}

# Summary output
output "dns_zone_names" {
  description = "Map of private DNS zone names to their IDs for easy reference"
  value = {
    for key, zone in module.avm-res-network-privatednszone : zone.resource.name => zone.resource.id
  }
}
