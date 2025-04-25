module "vwan_resourcegroup" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  location = var.location
  name     = local.resource_group_name
  tags     = var.resource_group_tags
}
