module "avm-ptn-hubnetworking" {
  source           = "Azure/avm-ptn-hubnetworking/azurerm"
  version          = "0.5.2"
  enable_telemetry = false

  hub_virtual_networks = {
    hub = {
      name                            = coalesce(var.hub_vnet_name, local.default_hub_vnet_name)
      address_space                   = [var.hub_vnet_address_space]
      location                        = var.location
      resource_group_name             = local.resource_group_name
      resource_group_creation_enabled = false
      resource_group_lock_enabled     = false

      mesh_peering_enabled = true
      subnets              = local.hub_subnets

      routing_address_space            = ["10.0.0.0/16"]
      route_table_name_user_subnets    = "rt-hub-default"
      route_table_name_firewall        = "rt-firewall"
      route_table_entries_firewall     = var.route_table_entries_firewall
      route_table_entries_user_subnets = var.route_table_entries_user_subnets

      firewall = {
        subnet_address_prefix = var.firewall_subnet_address_prefix
        name                  = local.hub_firewall_name
        sku_name              = "AZFW_VNet"
        sku_tier              = "Standard"
        zones                 = var.firewall_zones
        default_ip_configuration = {
          public_ip_config = {
            zones = ["1", "2", "3"]
          }
        }
        firewall_policy = {
          name = coalesce(var.firewall_policy_name, local.default_firewall_policy_name)
          dns = {
            proxy_enabled = true
          }
        }
        tags = var.firewall_tags
      }

      tags = var.vnet_tags
    }
  }

  depends_on = [module.avm-res-network-routetable, module.avm-res-network-networksecuritygroup]
}

