module "connectivity_resourcegroups" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  for_each = local.resource_groups

  location         = var.location
  name             = each.value.name
  tags             = each.value.tags
  lock             = each.value.lock
  role_assignments = each.value.role_assignments
}
