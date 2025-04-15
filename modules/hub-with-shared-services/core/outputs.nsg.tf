# Network Security Group Outputs
output "network_security_groups" {
  description = "Information about network security groups created in the network controls resource group"
  value = {
    for nsg_key, nsg in module.avm-res-network-networksecuritygroup : nsg_key => {
      resource    = nsg.resource
      name        = nsg.name
      resource_id = nsg.resource_id
    }
  }
}