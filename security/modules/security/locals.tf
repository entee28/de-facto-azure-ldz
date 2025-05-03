locals {
  location_code = local.get_region_code[var.location]
  environment   = "prd"
  name_suffix   = format("security-%s-%s", local.environment, local.location_code)

  default_resource_group_name           = format("rg-%s-platform-%s-001", var.company_name, local.name_suffix)
  default_security_virtual_network_name = format("vnet-platform-%s-001", local.name_suffix)
  default_log_analytics_workspace_name  = format("log-%s-001", local.name_suffix)

  resource_group_name           = coalesce(var.resource_group_name, local.default_resource_group_name)
  log_analytics_workspace_name  = coalesce(var.log_analytics_workspace_name, local.default_log_analytics_workspace_name)
  security_virtual_network_name = coalesce(var.virtual_network.name, local.default_security_virtual_network_name)
}
