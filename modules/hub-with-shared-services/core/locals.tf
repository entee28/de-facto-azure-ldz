locals {
  # Common naming components
  name_suffix = format("connectivity-%s-%s", var.environment, var.location_code)

  # Default resource group names
  default_hub_vnet_resource_group_name         = format("rg-%s-%s-001", var.company_name, local.name_suffix)
  default_shared_vnet_resource_group_name      = format("rg-%s-shared-%s-%s-001", var.company_name, var.environment, var.location_code)
  default_network_controls_resource_group_name = format("rg-%s-network-controls-%s-%s-001", var.company_name, var.environment, var.location_code)

  # Default resource names
  default_hub_vnet_name        = format("vnet-%s-001", local.name_suffix)
  default_shared_vnet_name     = format("vnet-%s-001", local.name_suffix)
  default_firewall_name        = format("afw-%s-001", local.name_suffix)
  default_firewall_policy_name = format("afw-policy-%s-001", local.name_suffix)

  # Resource group names
  hub_vnet_resource_group_name         = coalesce(var.hub_vnet_resource_group_name, local.default_hub_vnet_resource_group_name)
  shared_vnet_resource_group_name      = coalesce(var.shared_vnet_resource_group_name, local.default_shared_vnet_resource_group_name)
  network_controls_resource_group_name = coalesce(var.network_controls_resource_group_name, local.default_network_controls_resource_group_name)

  # Resource names
  hub_vnet_name     = coalesce(var.hub_vnet_name, local.default_hub_vnet_name)
  shared_vnet_name  = coalesce(var.shared_vnet_name, local.default_shared_vnet_name)
  hub_firewall_name = coalesce(var.firewall_name, local.default_firewall_name)

  # Subnet configurations with NSG and route table references
  hub_subnets = {
    for subnet_key, subnet_value in var.hub_subnets : subnet_key => merge(subnet_value, {
      nsg_id = subnet_value.nsg_name != null ? format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/networkSecurityGroups/%s",
        var.subscription_id,
        local.network_controls_resource_group_name,
        subnet_value.nsg_name
      ) : null
      route_table = subnet_value.nsg_name != null ? merge(subnet_value.route_table, {
        id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/routeTables/%s",
          var.subscription_id,
          local.network_controls_resource_group_name,
          subnet_value.route_table.name
        )
      }) : subnet_value.route_table
    })
  }

  shared_vnet_subnets = {
    for subnet_key, subnet_value in var.shared_vnet_subnets : subnet_key => merge(subnet_value, {
      nsg_id = subnet_value.nsg_name != null ? format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/networkSecurityGroups/%s",
        var.subscription_id,
        local.network_controls_resource_group_name,
        subnet_value.nsg_name
      ) : null
      route_table = subnet_value.nsg_name != null ? merge(subnet_value.route_table, {
        id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/routeTables/%s",
          var.subscription_id,
          local.network_controls_resource_group_name,
          subnet_value.route_table.name
        )
      }) : subnet_value.route_table
    })
  }
}
