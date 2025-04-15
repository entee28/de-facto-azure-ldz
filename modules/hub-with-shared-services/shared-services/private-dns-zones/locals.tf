locals {
  name_suffix = format("dns-private-%s-%s", var.environment, var.location_code)

  # Default resource group name
  default_resource_group_name = format("rg-%s-%s-001", var.company_name, local.name_suffix)

  # Resource names
  resource_group_name = coalesce(var.resource_group_name, local.default_resource_group_name)
}
