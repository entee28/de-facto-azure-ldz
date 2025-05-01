output "sidecar_virtual_networks" {
  description = "A map of sidecar virtual networks containing information about each VNet"
  value = {
    for k, v in module.connectivity_sidecar_virtualnetworks : k => {
      id        = v.resource_id
      name      = v.name
      subnets   = v.subnets
      location  = v.resource.location
      parent_id = v.resource.parent_id
    }
  }
}

output "virtual_wan" {
  description = "Information about the Virtual WAN and its components"
  value = {
    id                          = module.vwan_with_vhub.virtual_wan_id
    virtual_hub_name            = module.vwan_with_vhub.virtual_hub_resource_names["vhub"]
    virtual_hub_id              = module.vwan_with_vhub.virtual_hub_resource_ids["vhub"]
    vpn_gateway_name            = try(module.vwan_with_vhub.vpn_gateway_resource_names["vhub-vpn-gw"], null)
    vpn_gateway_id              = try(module.vwan_with_vhub.vpn_gateway_resource_ids["vhub-vpn-gw"], null)
    firewall_private_ip_address = module.vwan_with_vhub.firewall_private_ip_address["vhub-fw"]
    firewall_name               = module.vwan_with_vhub.firewall_resource_names["vhub-fw"]
    firewall_id                 = module.vwan_with_vhub.firewall_resource_ids["vhub-fw"]
  }
}

output "resource_groups" {
  description = "Information about all resource groups created by the module"
  value = {
    # Hub resource group (always created)
    hub = {
      id   = module.connectivity_resourcegroups[local.hub_resource_group_name].resource_id
      name = module.connectivity_resourcegroups[local.hub_resource_group_name].name
    }
    # Sidecar resource groups
    sidecar = {
      for name, rg in module.connectivity_resourcegroups : name => {
        id   = rg.resource_id
        name = rg.name
      } if name != local.hub_resource_group_name
    }
  }
}

output "firewall_policy" {
  description = "Information about the firewall policy"
  value = {
    id = module.connectivity_firewallpolicy.resource_id
  }
}
