locals {
  name_suffix = "platform-connectivity-prd"

  default_resource_group_name  = "rg-${var.company_name}-${local.name_suffix}-001"
  default_hub_vnet_name        = "vnet-${var.company_name}-${local.name_suffix}-001"
  default_firewall_name        = "afw-${var.company_name}-${local.name_suffix}-001"
  default_vnet_gateway_name    = "vgw-${var.company_name}-${local.name_suffix}-001"
  default_firewall_policy_name = "afw-policy-${var.company_name}-${local.name_suffix}-001"
  default_dns_resolver_name    = "dnspr-${var.company_name}-${local.name_suffix}-001"

  hub_vnet_name = coalesce(var.firewall_name, local.default_firewall_name)

  hubnetworking_output_vnet_id            = module.avm-ptn-hubnetworking.virtual_networks["hub"].virtual_network_resource_id
  hubnetworking_output_firewall_policy_id = module.avm-ptn-hubnetworking.firewall_policies[local.hub_vnet_name].id

  hub_subnets = {
    for subnet_key, subnet_value in var.hub_subnets : subnet_key => merge(subnet_value, {
      nsg_id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/networkSecurityGroups/%s",
        var.subscription_id,
        var.resource_group_name,
        subnet_value.nsg_name
      )
      route_table = merge(subnet_value.route_table, {
        id = format("/subscriptions/%s/resourceGroups/%s/providers/Microsoft.Network/routeTables/%s",
          var.subscription_id,
          var.resource_group_name,
          subnet_value.route_table.name
        )
      })
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
}