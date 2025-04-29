locals {
  location_code = local.get_region_code[var.location]

  # Default resource names
  default_resource_group_name = format("rg-%s-platform-shared-%s-%s-001", var.company_name, var.environment, local.location_code)
  default_dns_resolver_name   = format("dnspr-connectivity-%s-%s-001", var.environment, local.location_code)
  default_virtual_network_name = format("vnet-platform-shared-%s-%s-001", var.environment, local.location_code)
  default_virtual_network_resource_id = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s",
    var.subscription_id,
    local.default_resource_group_name,
    local.default_virtual_network_name
  )

  resource_group_name       = coalesce(var.resource_group_name, local.default_resource_group_name)
  private_dns_resolver_name = coalesce(var.name, local.default_dns_resolver_name)
  virtual_network_resource_id = coalesce(var.virtual_network_resource_id, local.default_virtual_network_resource_id)
}
