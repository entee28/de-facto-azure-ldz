# Route Table Outputs
output "route_tables" {
  description = "Information about route tables created in the network controls resource group"
  value = {
    for rt_key, rt in module.avm-res-network-routetable : rt_key => {
      name        = rt.name
      resource    = rt.resource
      routes      = rt.routes
      resource_id = rt.resource_id
    }
  }
}