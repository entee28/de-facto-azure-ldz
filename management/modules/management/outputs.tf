output "management_virtual_network" {
  description = "Information about the management virtual network"
  value = {
    id        = module.management_virtualnetwork.resource_id
    name      = module.management_virtualnetwork.name
    subnets   = module.management_virtualnetwork.subnets
    location  = module.management_virtualnetwork.resource.location
    parent_id = module.management_virtualnetwork.resource.parent_id
  }
}
