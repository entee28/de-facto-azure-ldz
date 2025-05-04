resource "azurerm_user_assigned_identity" "management" {
  location            = var.location
  name                = local.automation_account_managed_identity_name
  resource_group_name = module.management_resourcegroup.name
}

module "management" {
  source           = "Azure/avm-ptn-alz-management/azurerm"
  version          = "0.6.0"
  enable_telemetry = false

  automation_account_name         = local.automation_account_name
  location                        = var.location
  log_analytics_workspace_name    = local.log_analytics_workspace_name
  resource_group_name             = module.management_resourcegroup.name
  resource_group_creation_enabled = false

  automation_account_identity = {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.management.id]
  }

  automation_account_encryption                    = var.automation_account_encryption
  automation_account_local_authentication_enabled  = var.automation_account_local_authentication_enabled
  automation_account_public_network_access_enabled = var.automation_account_public_network_access_enabled
  automation_account_sku_name                      = var.automation_account_sku_name
  linked_automation_account_creation_enabled       = true

  log_analytics_solution_plans                               = var.log_analytics_solution_plans
  log_analytics_workspace_allow_resource_only_permissions    = true
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  log_analytics_workspace_retention_in_days                  = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku

  user_assigned_managed_identities = {
    ama = {
      name = local.monitor_agent_managed_identity_name
      tags = var.tags
    }
  }

  data_collection_rules = {
    change_tracking = {
      name = local.change_tracking_dcr_name
      tags = var.tags
    }
    vm_insights = {
      name = local.vm_insights_dcr_name
      tags = var.tags
    }
    defender_sql = {
      name = local.defender_sql_dcr_name
      tags = var.tags
    }
  }

  tags = var.tags

  depends_on = [module.management_resourcegroup]
}
