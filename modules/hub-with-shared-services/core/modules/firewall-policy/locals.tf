locals {
  name_suffix = "connectivity-prd-${var.location_code}"

  default_resource_group_name  = "rg-${var.company_name}-${local.name_suffix}-001"

  resource_group_name = coalesce(var.resource_group_name, local.default_resource_group_name)

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
