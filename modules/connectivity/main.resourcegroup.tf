module "avm-res-resources-resourcegroup" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  location = var.location
  name     = local.resource_group_name

  role_assignments = var.resource_group_role_assignments
  tags             = var.tags
}
