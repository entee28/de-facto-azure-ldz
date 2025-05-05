locals {
  subscription_id = "e799f190-b710-4b4f-807a-2a2ad232d4b4"
  company_name    = "fabrikam"
  location        = "southeastasia"

  name = {
    shared_services_resource_group_name  = "rg-fabrikam-platform-shared-prd-sea-001"
    shared_services_virtual_network_name = "vnet-platform-shared-prd-sea-001"
    dns_resolver_inbound_subnet_name     = "snet-dnspr-inbound-prd-sea-001"
    dns_resolver_outbound_subnet_name    = "snet-dnspr-outbound-prd-sea-001"
  }

  core = {
    virtual_hub = {
      address_prefix = "172.29.0.0/23"
    }

    firewall = {
      sku_tier = "Standard"
    }

    express_route_gateway = {}

    vpn_gateway = {}

    connectivity_sidecar_resourcegroups = {
      shared_services = {
        name = local.name.shared_services_resource_group_name
      }
      appgw = {
        name = "rg-fabrikam-platform-appgw-prd-sea-001"
      }
      partner = {
        name = "rg-fabrikam-platform-partner-prd-sea-001"
      }
    }

    sidecar_vnets = {
      shared_services = {
        name                = local.name.shared_services_virtual_network_name
        address_space       = ["172.29.2.0/23"]
        resource_group_name = local.name.shared_services_resource_group_name
        subnets = {
          dnspr_inbound = {
            name           = "snet-dnspr-inbound-prd-sea-001"
            address_prefix = "172.29.2.0/27"
            delegation = [
              {
                name = "Microsoft.Network/dnsResolvers"
                service_delegation = {
                  name = "Microsoft.Network/dnsResolvers"
                }
              }
            ]
          }
          dnspr_outbound = {
            name           = "snet-dnspr-outbound-prd-sea-001"
            address_prefix = "172.29.2.32/27"
            delegation = [
              {
                name = "Microsoft.Network/dnsResolvers"
                service_delegation = {
                  name = "Microsoft.Network/dnsResolvers"
                }
              }
            ]
          }
          jump = {
            name           = "snet-jump-prd-sea-001"
            address_prefix = "172.29.2.64/28"
          }
        }
      }
      partner = {
        name                = "vnet-platform-partner-prd-sea-001"
        address_space       = ["172.29.6.0/24"]
        resource_group_name = "rg-fabrikam-platform-partner-prd-sea-001"
      }
      appgw = {
        name                = "vnet-platform-appgw-prd-sea-001"
        address_space       = ["172.29.7.0/24"]
        resource_group_name = "rg-fabrikam-platform-appgw-prd-sea-001"
      }
    }

    firewall_policy = {
      sku = "Standard"
      dns = {
        proxy_enabled = true
        servers       = ["172.29.2.4"]
      }
    }
  }

  private_dns_zones = {
    stb-local = {
      domain_name = "stb.local"
    }
  }
}
