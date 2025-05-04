data "azapi_client_config" "current" {}

module "alz" {
  source           = "Azure/avm-ptn-alz/azurerm"
  version          = "0.12.0"
  enable_telemetry = false

  architecture_name  = "stb"
  parent_resource_id = data.azapi_client_config.current.tenant_id
  location           = var.location
}
