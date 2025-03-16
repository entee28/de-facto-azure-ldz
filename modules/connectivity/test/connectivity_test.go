package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConnectivityLDZModule(t *testing.T) {
	t.Parallel()

	hubSubnets := map[string]interface{}{
		"dnspr-in": map[string]interface{}{
			"name":             "snet-dnspr-in-prd-sea-001",
			"address_prefixes": []string{"10.10.1.0/27"},
			"delegation": map[string]interface{}{
				"name": "dnsResolvers",
				"service_delegation": map[string]interface{}{
					"name":    "Microsoft.Network/dnsResolvers",
					"actions": []string{"Microsoft.Network/virtualNetworks/subnets/join/action"},
				},
			},
		},
		"dnspr-out": map[string]interface{}{
			"name":             "snet-dnspr-out-prd-sea-001",
			"address_prefixes": []string{"10.10.1.32/27"},
			"delegation": map[string]interface{}{
				"name": "dnsResolvers",
				"service_delegation": map[string]interface{}{
					"name":    "Microsoft.Network/dnsResolvers",
					"actions": []string{"Microsoft.Network/virtualNetworks/subnets/join/action"},
				},
			},
		},
		"test": map[string]interface{}{
			"name":             "snet-dnspr-outbound-prd-sea-001",
			"address_prefixes": []string{"10.10.2.0/24"},
			"route_table": map[string]interface{}{
				"assign_generated_route_table": false,
				"name":                         "rt-snet-test",
			},
		},
	}

	userRouteTables := map[string]interface{}{
		"rt-snet-test": map[string]interface{}{
			"name": "rt-snet-test",
		},
	}

	userNetworkSecurityGroups := map[string]interface{}{
		"nsg-snet-test": map[string]interface{}{
			"name": "nsg-snet-test",
		},
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "..",
		Vars: map[string]interface{}{
			"company_name":                   "contoso",
			"subscription_id":                "986c8c85-5175-4773-a272-40983cf0c60d",
			"location":                       "southeastasia",
			"hub_vnet_address_space":         "10.10.0.0/16",
			"firewall_subnet_address_prefix": "10.10.0.0/24",
			"firewall_zones":                 []string{"1"},
			"route_table_entries_user_subnets": []interface{}{
				map[string]interface{}{
					"name":                   "route-to-all",
					"address_prefix":         "0.0.0.0/0",
					"next_hop_type":          "VirtualAppliance",
					"next_hop_in_ip_address": "10.10.0.4",
				},
			},
			"hub_subnets":                  hubSubnets,
			"user_route_tables":            userRouteTables,
			"user_network_security_groups": userNetworkSecurityGroups,
			"dnsresolver_inbound_endpoints": map[string]interface{}{
				"dnspr-inbound": map[string]interface{}{
					"name":        "in-dnspr-connectivity-prd-sea-001",
					"subnet_name": "snet-dnspr-in-prd-sea-001",
				},
			},
			"dnsresolver_outbound_endpoints": map[string]interface{}{
				"dnspr-outbound": map[string]interface{}{
					"name":        "out-dnspr-connectivity-prd-sea-001",
					"subnet_name": "snet-dnspr-out-prd-sea-001",
					"forwarding_ruleset": map[string]interface{}{
						"frs-dnspr-outbound": map[string]interface{}{
							"name":  "frs-dnspr-outbound",
							"rules": map[string]interface{}{},
						},
					},
				},
			},
			"vnetgateway_subnet_address_prefix": "10.10.2.0/24",
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert.Equal(t, true, true)
}
