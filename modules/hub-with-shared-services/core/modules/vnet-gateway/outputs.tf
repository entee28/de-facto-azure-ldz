# Gateway Outputs
output "gateway" {
  description = "Information about the Virtual Network Gateway"
  value       = module.avm-ptn-vnetgateway
}

# Local Network Gateway Outputs
output "local_network_gateways" {
  description = "Information about configured Local Network Gateways"
  value = {
    for key, gateway in module.avm-ptn-vnetgateway.local_network_gateways : key => gateway
  }
}