locals {
  name_suffix = "connectivity-prd-${var.location_code}"

  default_resource_group_name  = "rg-${var.company_name}-${local.name_suffix}-001"
  default_hub_vnet_name        = "vnet-${local.name_suffix}-001"
  default_firewall_name        = "afw-${local.name_suffix}-001"
  default_vnet_gateway_name    = "vgw-${local.name_suffix}-001"
  default_firewall_policy_name = "afw-policy-${local.name_suffix}-001"
  default_dns_resolver_name    = "dnspr-${local.name_suffix}-001"
  default_bastion_host_name    = "bas-${local.name_suffix}-001"
  default_monitor_privatelinkscope_name = "ampls-${local.name_suffix}-001"

  resource_group_name = coalesce(var.resource_group_name, local.default_resource_group_name)
  private_dns_zone_resource_group_name = coalesce(var.private_dns_zones_resource_group_name, local.default_resource_group_name)
  hub_vnet_name = coalesce(var.hub_vnet_name, local.default_hub_vnet_name)
  hub_firewall_name = coalesce(var.firewall_name, local.default_firewall_name)

  hubnetworking_output_vnet_id            = module.avm-ptn-hubnetworking.virtual_networks["hub"].virtual_network_resource_id
  hubnetworking_output_vnet_id            = module.avm-ptn-hubnetworking.virtual_networks["hub"].virtual_network_resource_id
  hubnetworking_output_firewall_policy_id = module.avm-ptn-hubnetworking.firewall_policies["hub"].id

  hub_subnets = {
    for subnet_key, subnet_value in var.hub_subnets : subnet_key => merge(subnet_value, {
      nsg_id = subnet_value.nsg_name != null ?
        format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/networkSecurityGroups/%s",
          var.subscription_id,
          local.resource_group_name,
          subnet_value.nsg_name
        ) : null
      route_table = subnet_value.nsg_name != null ? merge(subnet_value.route_table, {
        id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/routeTables/%s",
          var.subscription_id,
          local.resource_group_name,
          subnet_value.route_table.name
        )
      }) : subnet_value.route_table
    })
  }

  firewall_policy_rule_collection_groups = {
    emergency = {
      name                        = "rcg-emergency"
      priority                    = 200
      application_rule_collection = var.rcg_emergency_application_rule_collection
      network_rule_collection     = var.rcg_emergency_network_rule_collection
      nat_rule_collection         = var.rcg_emergency_nat_rule_collection
    }
    common-internet-prd = {
      name                        = "rcg-common-internet-prd"
      priority                    = 300
      application_rule_collection = var.rcg_common_internet_prd_application_rule_collection
      network_rule_collection     = var.rcg_common_internet_prd_network_rule_collection
      nat_rule_collection         = var.rcg_common_internet_prd_nat_rule_collection
    }
    common-internal-prd = {
      name                        = "rcg-common-internal-prd"
      priority                    = 400
      application_rule_collection = var.rcg_common_internal_prd_application_rule_collection
      network_rule_collection     = var.rcg_common_internal_prd_network_rule_collection
      nat_rule_collection         = var.rcg_common_internal_prd_nat_rule_collection
    }
    common-internet-stg = {
      name                        = "rcg-common-internet-stg"
      priority                    = 500
      application_rule_collection = var.rcg_common_internet_stg_application_rule_collection
      network_rule_collection     = var.rcg_common_internet_stg_network_rule_collection
      nat_rule_collection         = var.rcg_common_internet_stg_nat_rule_collection
    }
    common-internal-stg = {
      name                        = "rcg-common-internal-stg"
      priority                    = 600
      application_rule_collection = var.rcg_common_internal_stg_application_rule_collection
      network_rule_collection     = var.rcg_common_internal_stg_network_rule_collection
      nat_rule_collection         = var.rcg_common_internal_stg_nat_rule_collection
    }
    base = {
      name                        = "rcg-base"
      priority                    = 700
      application_rule_collection = var.rcg_base_application_rule_collection
      network_rule_collection     = var.rcg_base_network_rule_collection
      nat_rule_collection         = var.rcg_base_nat_rule_collection
    }
  }

  ampls_private_dns_zones_name = [
    "privatelink.agentsvc.azure-automation.net",
    "privatelink.blob.core.windows.net",
    "privatelink.monitor.azure.com",
    "privatelink.ods.opinsights.azure.com",
    "privatelink.oms.opinsights.azure.com"
  ]

  ampls_private_dns_zone_ids = [
    for zone in local.ampls_private_dns_zones_name : format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/privateDnsZones/%s",
      var.subscription_id,
      local.private_dns_zone_resource_group_name
      zone
    )
  ]
}
