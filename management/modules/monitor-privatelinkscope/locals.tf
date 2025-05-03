locals {
  location_code = local.get_region_code[var.location]
  environment   = "prd"
  name_suffix   = format("management-%s-%s", local.environment, local.location_code)

  default_resource_group_name                     = format("rg-%s-platform-%s-001", var.company_name, local.name_suffix)
  default_ampls_name                              = format("ampls-platform-%s-001", local.name_suffix)
  default_private_endpoint_name                   = format("pe-ampls-%s-001", local.name_suffix)
  default_private_endpoint_network_interface_name = format("nic-pe-ampls-%s-001", local.name_suffix)
  default_private_dns_zone_resource_group_name    = format("rg-%s-platform-shared-%s-%s-001", var.company_name, local.environment, local.location_code)

  resource_group_name                     = coalesce(var.resource_group_name, local.default_resource_group_name)
  ampls_name                              = coalesce(var.azure_monitor_private_link_scope_name, local.default_ampls_name)
  private_endpoint_name                   = coalesce(var.private_endpoint.name, local.default_private_endpoint_name)
  private_endpoint_network_interface_name = coalesce(var.private_endpoint.network_interface_name, local.default_private_endpoint_network_interface_name)
  private_dns_zone_resource_group_name    = coalesce(var.private_endpoint.private_dns_zone_resource_group_name, local.default_private_dns_zone_resource_group_name)

  ampls_private_dns_zones_name = [
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.monitor.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.oms.opinsights.azure.com"
  ]
  ampls_private_dns_zone_ids = [
    for zone in local.ampls_private_dns_zones_name : format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/privateDnsZones/%s",
      var.private_endpoint.private_dns_zone_subscription_id,
      local.private_dns_zone_resource_group_name,
      zone
    )
  ]
}
