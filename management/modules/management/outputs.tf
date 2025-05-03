output "management_virtual_network" {
  description = "Information about the management virtual network"
  value = {
    id        = module.management_virtualnetwork.resource_id
    name      = module.management_virtualnetwork.name
    subnets   = module.management_virtualnetwork.subnets
    location  = module.management_virtualnetwork.resource.location
    parent_id = module.management_virtualnetwork.resource.parent_id
  }
}

output "management_log_analytics_workspace" {
  description = "Information about the management log analytics workspace"
  value = {
    id                           = module.management.resource_id
    log_analytics_workspace      = module.management.log_analytics_workspace
    log_analytics_workspace_keys = module.management.log_analytics_workspace_keys
  }
}

output "management_automation_account" {
  value = {
    id = module.management.automation_account.id
  }
}