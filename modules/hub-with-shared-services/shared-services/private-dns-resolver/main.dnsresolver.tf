module "avm-res-network-dnsresolver" {
  source           = "Azure/avm-res-network-dnsresolver/azurerm"
  version          = "0.7.2"
  enable_telemetry = false

  location                    = var.location
  resource_group_name         = local.resource_group_name
  virtual_network_resource_id = local.virtual_network_resource_id
  name                        = local.private_dns_resolver_name

  inbound_endpoints  = var.inbound_endpoints
  outbound_endpoints = var.outbound_endpoints

  role_assignments = var.role_assignments

  tags = var.tags
}
