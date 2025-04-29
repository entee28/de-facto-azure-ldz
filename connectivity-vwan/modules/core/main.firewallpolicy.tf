module "connectivity_firewallpolicy" {
  source           = "Azure/avm-res-network-firewallpolicy/azurerm"
  version          = "0.3.3"
  enable_telemetry = false

  name                = local.firewall_policy_name
  location            = var.location
  resource_group_name = local.hub_resource_group_name

  firewall_policy_auto_learn_private_ranges_enabled = var.firewall_policy.auto_learn_private_ranges_enabled
  firewall_policy_dns                               = var.firewall_policy.dns
  firewall_policy_identity                          = var.firewall_policy.identity
  firewall_policy_insights                          = var.firewall_policy.insights
  firewall_policy_intrusion_detection               = var.firewall_policy.intrusion_detection
  firewall_policy_private_ip_ranges                 = var.firewall_policy.private_ip_ranges
  firewall_policy_sku                               = var.firewall_policy.sku
  firewall_policy_sql_redirect_allowed              = var.firewall_policy.sql_redirect_allowed
  firewall_policy_threat_intelligence_allowlist     = var.firewall_policy.threat_intelligence_allowlist
  firewall_policy_threat_intelligence_mode          = var.firewall_policy.threat_intelligence_mode
  firewall_policy_tls_certificate                   = var.firewall_policy.tls_certificate

  diagnostic_settings = var.firewall_policy.diagnostic_settings
  lock                = var.firewall_policy.lock
  role_assignments    = var.firewall_policy.role_assignments
  tags                = var.firewall_policy.tags

  depends_on = [module.connectivity_resourcegroups]
}
