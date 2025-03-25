locals {
  resource_group_location = try(data.azurerm_resource_group.parent[0].location, null)

  private_endpoint_ip_configurations = {
    for pe_key, pe_value in var.private_endpoint : pe_key => merge(pe_value, {
      ip_configurations = length(pe_value.ip_configurations) > 0 ? {
        for ip_key, ip_value in pe_value.ip_configurations : ip_key => merge(ip_value, {
          subresource_name = "azuremonitor"
          member_name      = "azuremonitor"
        })
      } : pe_value.ip_configurations
    })
  }
}