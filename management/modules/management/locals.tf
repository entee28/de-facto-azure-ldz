locals {
  location_code = local.get_region_code[var.location]
  environment   = "prd"
  name_suffix   = format("management-%s-%s", local.environment, local.location_code)

  default_resource_group_name             = format("rg-%s-platform-%s-001", var.company_name, local.name_suffix)
  default_automation_account_name         = format("aa-%s-001", local.name_suffix)
  default_management_virtual_network_name = format("vnet-platform-%s-001", local.name_suffix)
  default_log_analytics_workspace_name    = format("log-%s-001", local.name_suffix)

  resource_group_name             = coalesce(var.resource_group_name, local.default_resource_group_name)
  automation_account_name         = coalesce(var.automation_account_name, local.default_automation_account_name)
  log_analytics_workspace_name    = coalesce(var.log_analytics_workspace_name, local.default_log_analytics_workspace_name)
  management_virtual_network_name = coalesce(var.virtual_network.name, local.default_management_virtual_network_name)
}
