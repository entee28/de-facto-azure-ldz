# Firewall Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "firewall_diagnostic_settings" {
  for_each = var.firewall != null ? var.firewall.diagnostic_settings : {}

  name                           = each.value.name != null ? each.value.name : "diag-${local.firewall_name}"
  target_resource_id             = module.vwan_with_vhub.firewall_resource_ids["vhub-fw"]
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
  depends_on = [module.vwan_with_vhub]
}

# VPN Gateway Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vpn_gateway_diagnostic_settings" {
  for_each = var.vpn_gateway != null ? var.vpn_gateway_diagnostic_settings : {}

  name                           = each.value.name != null ? each.value.name : "diag-${local.vpn_gateway_name}"
  target_resource_id             = module.vwan_with_vhub.vpn_gateway_resource_ids["vhub-vpn-gw"]
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories

    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups

    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
  depends_on = [module.vwan_with_vhub]
}

# ExpressRoute Gateway Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "express_route_gateway_diagnostic_settings" {
  for_each = local.express_route_gateway_resource_id != null ? var.express_route_gateway_diagnostic_settings : {}

  name                           = each.value.name != null ? each.value.name : "diag-${local.express_route_gateway_name}"
  target_resource_id             = local.express_route_gateway_resource_id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "metric" {
    for_each = each.value.metric_categories

    content {
      category = metric.value
    }
  }
  depends_on = [module.vwan_with_vhub]
}
