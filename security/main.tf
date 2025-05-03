module "security" {
  source = "./modules/security"

  company_name   = local.company_name
  location       = local.location
  virtual_hub_id = local.virtual_hub_id
  virtual_network = {
    address_space = ["172.29.4.0/24"]
    dns_servers = {
      dns_servers = ["172.29.2.4"]
    }
  }
  monitor_private_link_scope_resource_id = local.monitor_private_link_scope_resource_id
}
