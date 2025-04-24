package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestConnectivityVwan(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"subscription_id": "e799f190-b710-4b4f-807a-2a2ad232d4b4",
			"company_name":    "contoso",
			"location":        "southeastasia",
			"resource_group_tags": map[string]interface{}{
				"environment": "test",
				"managed_by":  "terratest",
			},
			"virtual_hub": map[string]interface{}{
				"address_prefix": "10.165.0.0/23",
			},
			"firewall": map[string]interface{}{
				"sku_tier": "Premium",
			},
			"firewall_policy": map[string]interface{}{
				"sku":                      "Premium",
				"threat_intelligence_mode": "Alert",
			},
			"private_dns_zones": map[string]interface{}{
				"subnet_address_prefix": "10.166.0.0/24",
				"private_link_private_dns_zones": map[string]interface{}{
					"blob": map[string]interface{}{
						"zone_name": "privatelink.blob.core.windows.net",
					},
				},
				"private_dns_resolver": map[string]interface{}{
					"ip_address": "10.166.0.4",
				},
			},
			"express_route_gateway": map[string]interface{}{
				"scale_units": 1,
			},
			"vpn_gateway": map[string]interface{}{
				"bgp_settings": map[string]interface{}{
					"asn":         65515,
					"peer_weight": 0,
				},
				"scale_unit": 1,
			},
			"side_car_virtual_network": map[string]interface{}{
				"address_space": []string{"10.166.0.0/16"},
				"subnets": map[string]interface{}{
					"dummy": map[string]interface{}{
						"name":           "snet-dummy",
						"address_prefix": "10.166.0.0/27",
					},
				},
			},
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)
}
