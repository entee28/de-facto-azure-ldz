module "management_resourcegroup" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  location = var.location
  name     = local.resource_group_name

  lock             = var.resource_group_lock
  role_assignments = var.resource_group_role_assignments
  tags             = merge(var.tags, var.resource_group_tags)
}
