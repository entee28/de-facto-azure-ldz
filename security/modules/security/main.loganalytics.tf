resource "random_id" "suffix" {
  byte_length = 2
}

module "security_log_analytics_workspace" {
  source           = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version          = "0.4.2"
  enable_telemetry = false

  location            = var.location
  resource_group_name = module.security_resourcegroup.name
  name                = local.log_analytics_workspace_name

  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  log_analytics_workspace_retention_in_days                  = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku
  log_analytics_workspace_identity = {
    type = "SystemAssigned"
  }
  role_assignments = var.role_assignments

  monitor_private_link_scoped_resource = {
    ampls = {
      resource_id = var.monitor_private_link_scope_resource_id
    }
  }
  monitor_private_link_scoped_service_name = "amplsservice-${random_id.suffix.hex}"

  tags = var.tags
}
