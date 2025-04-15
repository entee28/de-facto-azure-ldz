# Resource Group for Network Controls (NSGs and Route Tables)
module "avm-res-network-controls-resourcegroup" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  name     = local.network_controls_resource_group_name
  location = var.location

  role_assignments = var.network_controls_resource_group_role_assignments
  tags = merge(var.tags, {
    purpose = "network-controls"
  })
}
