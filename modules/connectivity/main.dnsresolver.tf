module "avm-res-network-dnsresolver" {
  source           = "Azure/avm-res-network-dnsresolver/azurerm"
  version          = "0.7.2"
  enable_telemetry = false

  location                    = var.location
  resource_group_name         = local.resource_group_name
  virtual_network_resource_id = local.hubnetworking_output_vnet_id
  name                        = coalesce(var.dnsresolver_name, local.default_dns_resolver_name)

  inbound_endpoints  = var.dnsresolver_inbound_endpoints
  outbound_endpoints = var.dnsresolver_outbound_endpoints

  tags = var.dnsresolver_tags
}
