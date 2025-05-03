module "core" {
  source          = "./modules/core"
  subscription_id = local.subscription_id
  company_name    = local.company_name
  location        = local.location

  virtual_hub = local.core.virtual_hub
  # firewall                            = local.core.firewall
  # express_route_gateway               = local.core.express_route_gateway
  # vpn_gateway                         = local.core.vpn_gateway
  connectivity_sidecar_resourcegroups = local.core.connectivity_sidecar_resourcegroups
  sidecar_vnets                       = local.core.sidecar_vnets
  firewall_policy                     = local.core.firewall_policy
}

# module "private_dns_resolver" {
#   source          = "./modules/shared-services/private-dns-resolver"
#   subscription_id = local.subscription_id
#   company_name    = local.company_name
#   location        = local.location

#   inbound_endpoints = {
#     inbound = {
#       subnet_name                  = local.name.dns_resolver_inbound_subnet_name
#       private_ip_allocation_method = "Static"
#       private_ip_address           = "172.29.2.4"
#     }
#   }
#   outbound_endpoints = {
#     outbound = {
#       subnet_name = local.name.dns_resolver_outbound_subnet_name
#     }
#   }
# }

module "private_link_private_dns_zones" {
  source          = "./modules/shared-services/private-link-private-dns-zones"
  company_name    = local.company_name
  subscription_id = local.subscription_id
  location        = local.location

  depends_on = [module.core]
}

module "private_dns_zones" {
  source            = "./modules/shared-services/private-dns-zones"
  company_name      = local.company_name
  subscription_id   = local.subscription_id
  location          = local.location
  private_dns_zones = local.private_dns_zones

  depends_on = [module.core]
}

module "firewall_policy_rule_collection_groups" {
  source                                                   = "./modules/firewall-policy-rule-collection-groups"
  firewall_policy_rule_collection_group_firewall_policy_id = module.core.firewall_policy.id
  rcg_base_application_rule_collection = [
    {
      name     = "rcg-base-application-rule-collection"
      action   = "Allow"
      priority = 100
      rule = [
        {
          name              = "rule-app-github"
          protocols         = [{ type = "Https", port = "443" }]
          source_addresses  = ["127.29.0.0/17"]
          destination_fqdns = ["github.com"],
        }
      ]
    }
  ]

  depends_on = [module.core]
}
