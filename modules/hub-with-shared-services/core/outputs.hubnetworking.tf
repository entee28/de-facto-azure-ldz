# Virtual Network Outputs
output "virtual_networks" {
  description = "Information about all virtual networks"
  value = {
    for vnet_key, vnet in module.avm-ptn-hubnetworking.virtual_networks : vnet_key => vnet
  }
}

# Quick access outputs for default networks
output "hub_network" {
  description = "Information about the hub virtual network"
  value       = try(module.avm-ptn-hubnetworking.virtual_networks["hub"], null)
}

output "shared_services_network" {
  description = "Information about the shared services virtual network"
  value       = try(module.avm-ptn-hubnetworking.virtual_networks["shared_services"], null)
}

# Firewall Outputs
output "firewall" {
  description = "Information about the Azure Firewall and its policy"
  value = try(module.avm-ptn-hubnetworking.firewalls["hub"], null)
}
