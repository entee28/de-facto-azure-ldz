module "vwan_resourcegroup" {
  for_each = {
    "vwan-rg" = {
      name = local.resource_group_name
    }
    "shared-services-rg" = {
      name = local.shared_services_rg_name
    }
  }
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  enable_telemetry = false

  location = var.location
  name     = each.value.name
  tags     = var.resource_group_tags
}
