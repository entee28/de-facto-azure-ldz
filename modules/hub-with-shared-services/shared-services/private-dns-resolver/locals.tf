locals {
  name_suffix = format("connectivity-%s-%s", var.environment, var.location_code)

  # Default resource group names
  default_resource_group_name = format("rg-%s-shared-%s-%s-001", var.company_name, var.environment, var.location_code)
  default_dns_resolver_name   = format("dnspr-%s-%s-001", var.company_name, local.name_suffix)

  # Resource names
  resource_group_name       = coalesce(var.resource_group_name, local.default_resource_group_name)
  private_dns_resolver_name = coalesce(var.name, local.default_dns_resolver_name)

  virtual_network_resource_id = format(
    "/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/virtualNetworks/%s",
    var.subscription_id,
    local.resource_group_name,
    var.virtual_network_name
  )
}
