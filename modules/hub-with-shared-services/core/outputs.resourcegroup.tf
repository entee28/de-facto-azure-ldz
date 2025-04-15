# Resource Group Outputs
output "resource_groups" {
  description = "Information about all resource groups created by the module"
  value = {
    network_controls = {
      name        = module.avm-res-network-controls-resourcegroup.name
      resource_id = module.avm-res-network-controls-resourcegroup.resource_id
      resource    = module.avm-res-network-controls-resourcegroup.resource
    }
  }
}
