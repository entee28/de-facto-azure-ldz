output "resource_group_name" {
  description = "The name of the resource group"
  value       = local.resource_group_name
}

output "virtual_wan_name" {
  description = "The name of the Virtual WAN"
  value       = local.virtual_wan_name
}

output "virtual_hub_name" {
  description = "The name of the Virtual Hub"
  value       = local.virtual_hub_name
}

output "firewall_name" {
  description = "The name of the Azure Firewall"
  value       = local.firewall_name
}

output "vpn_gateway_name" {
  description = "The name of the VPN Gateway"
  value       = local.vpn_gateway_name
}

output "express_route_gateway_name" {
  description = "The name of the ExpressRoute Gateway"
  value       = local.express_route_gateway_name
}
