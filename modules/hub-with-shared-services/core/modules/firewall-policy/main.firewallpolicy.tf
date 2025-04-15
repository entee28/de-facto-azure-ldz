module "avm-res-network-firewallpolicy" {
  for_each = local.firewall_policy_rule_collection_groups
  source   = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version  = "0.3.3"

  firewall_policy_rule_collection_group_firewall_policy_id          = var.firewall_policy_resource_id
  firewall_policy_rule_collection_group_name                        = each.value.name
  firewall_policy_rule_collection_group_priority                    = each.value.priority
  firewall_policy_rule_collection_group_application_rule_collection = each.value.application_rule_collection
  firewall_policy_rule_collection_group_network_rule_collection     = each.value.network_rule_collection
  firewall_policy_rule_collection_group_nat_rule_collection         = each.value.nat_rule_collection
}
