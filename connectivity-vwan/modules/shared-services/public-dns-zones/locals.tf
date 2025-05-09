locals {
  location_code = local.get_region_code[var.location]

  default_resource_group_name = format("rg-%s-platform-shared-%s-%s-001", var.company_name, var.environment, local.location_code)
  resource_group_name         = coalesce(var.resource_group_name, local.default_resource_group_name)
}
