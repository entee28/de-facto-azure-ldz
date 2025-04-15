locals {
  default_resource_group_name = format("rg-%s-connectivity-dnszone-%s-%s-001", var.company_name, var.environment, var.location_code)
  resource_group_name         = coalesce(var.resource_group_name, local.default_resource_group_name)
}
