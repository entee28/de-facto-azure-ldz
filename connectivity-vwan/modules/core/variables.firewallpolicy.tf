variable "firewall_policy" {
  type = object({
    name = optional(string, null)
    diagnostic_settings = optional(map(object({
      name                                     = optional(string, null)
      log_categories                           = optional(set(string), [])
      log_groups                               = optional(set(string), ["allLogs"])
      metric_categories                        = optional(set(string), ["AllMetrics"])
      log_analytics_destination_type           = optional(string, "Dedicated")
      workspace_resource_id                    = optional(string, null)
      storage_account_resource_id              = optional(string, null)
      event_hub_authorization_rule_resource_id = optional(string, null)
      event_hub_name                           = optional(string, null)
      marketplace_partner_resource_id          = optional(string, null)
    })), {})
    auto_learn_private_ranges_enabled = optional(bool, null)
    dns = optional(object({
      proxy_enabled = optional(bool)
      servers       = optional(list(string))
    }), {})
    identity = optional(object({
      identity_ids = optional(set(string))
      type         = string
    }), null)
    insights = optional(object({
      default_log_analytics_workspace_id = string
      enabled                            = bool
      retention_in_days                  = optional(number)
      log_analytics_workspace = optional(list(object({
        firewall_location = string
        id                = string
      })))
    }), null)
    intrusion_detection = optional(object({
      mode           = optional(string)
      private_ranges = optional(list(string))
      signature_overrides = optional(list(object({
        id    = optional(string)
        state = optional(string)
      })))
      traffic_bypass = optional(list(object({
        description           = optional(string)
        destination_addresses = optional(set(string))
        destination_ip_groups = optional(set(string))
        destination_ports     = optional(set(string))
        name                  = string
        protocol              = string
        source_addresses      = optional(set(string))
        source_ip_groups      = optional(set(string))
      })))
    }), null)
    private_ip_ranges    = optional(list(string), null)
    sku                  = string
    sql_redirect_allowed = optional(bool, null)
    threat_intelligence_allowlist = optional(object({
      fqdns        = optional(set(string))
      ip_addresses = optional(set(string))
    }), null)
    threat_intelligence_mode = optional(string, "Alert")
    tls_certificate = optional(object({
      key_vault_secret_id = string
      name                = string
    }), null)
    lock = optional(object({
      kind = string
      name = optional(string, null)
    }), null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })), {})
    tags = optional(map(string), {})
  })
}
