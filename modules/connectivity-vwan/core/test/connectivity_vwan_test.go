package test

import (
	"fmt"
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConnectivityVwan(t *testing.T) {
	t.Parallel()

	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if subscriptionID == "" {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	// Generate a random name
	uniqueId := random.UniqueId()
	companyName := fmt.Sprintf("tf-test-%s", uniqueId)

	// Construct the terraform options with default retryable errors
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"company_name":        companyName,
			"location":            "eastus",
			"resource_group_name": fmt.Sprintf("rg-%s-connectivity-eus-prd", companyName),
			"resource_group_tags": map[string]interface{}{
				"environment": "test",
				"managed_by":  "terratest",
			},
			"virtual_hub": map[string]interface{}{
				"address_prefix": "10.0.0.0/23",
			},
			"firewall": map[string]interface{}{
				"sku_tier": "Standard",
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
		},
	})

	// At the end of the test, clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Deploy the resources
	terraform.InitAndApply(t, terraformOptions)

	// Get the resource group name from output
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

	// Verify Resource Group exists
	exists := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
	assert.True(t, exists, "Resource group does not exist")

	// Verify Virtual WAN exists
	vwanName := terraform.Output(t, terraformOptions, "virtual_wan_name")
	assert.NotEmpty(t, vwanName, "Virtual WAN name is empty")

	// Verify Virtual Hub exists
	vhubName := terraform.Output(t, terraformOptions, "virtual_hub_name")
	assert.NotEmpty(t, vhubName, "Virtual Hub name is empty")

	// Verify Firewall exists
	firewallName := terraform.Output(t, terraformOptions, "firewall_name")
	assert.NotEmpty(t, firewallName, "Firewall name is empty")

	// Verify VPN Gateway exists
	vpnGatewayName := terraform.Output(t, terraformOptions, "vpn_gateway_name")
	assert.NotEmpty(t, vpnGatewayName, "VPN Gateway name is empty")

	// Verify ExpressRoute Gateway exists
	erGatewayName := terraform.Output(t, terraformOptions, "express_route_gateway_name")
	assert.NotEmpty(t, erGatewayName, "ExpressRoute Gateway name is empty")
}
