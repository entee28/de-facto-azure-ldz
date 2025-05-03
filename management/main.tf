module "management" {
  source = "./modules/management"

  company_name = local.company_name
  location     = local.location
  management_virtual_network = {
    address_space = ["172.29.4.0/24"]
    dns_servers = {
      dns_servers = ["172.29.2.4"]
    }
    subnets = {
      ampls = {
        name           = "snet-ampls-prd-sea-001"
        address_prefix = "172.29.4.0/25"
      }
    }
  }
}

module "monitor-privatelinkscope" {
  source = "./modules/monitor-privatelinkscope"

  company_name = local.company_name
  location     = local.location
  private_endpoint = {
    private_dns_zone_subscription_id = local.subscription_id
    subnet_id                        = module.management.management_virtual_network.subnets["ampls"].resource_id
  }
}
