resource "random_id" "suffix" {
  byte_length = 2
}

resource "azapi_resource" "ampls_service_logws" {
  name      = "amplsservice-${random_id.suffix.hex}"
  type      = "Microsoft.Insights/privateLinkScopes/scopedResources@2021-07-01-preview"
  parent_id = var.monitor_private_link_scope_resource_id

  body = {
    properties = {
      linkedResourceId = var.service_resource_id
    }
  }

  ignore_casing = true
}
