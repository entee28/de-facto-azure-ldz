package test

import (
	"context"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestConnectivityVwan(t *testing.T) {
	t.Parallel()

	// subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	// if subscriptionID == "" {
	// 	t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	// }
	subscriptionID := "986c8c85-5175-4773-a272-40983cf0c60d"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"subscription_id": subscriptionID,
			"company_name":    "contoso",
			"location":        "southeastasia",
			"resource_group_tags": map[string]interface{}{
				"environment": "test",
				"managed_by":  "terratest",
			},
			"virtual_hub": map[string]interface{}{
				"address_prefix": "10.0.0.0/23",
			},
			"firewall": map[string]interface{}{
				"sku_tier": "Premium",
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

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Get outputs
	rgName := terraform.Output(t, terraformOptions, "resource_group_name")
	vwanName := terraform.Output(t, terraformOptions, "virtual_wan_name")
	vhubName := terraform.Output(t, terraformOptions, "virtual_hub_name")
	fwName := terraform.Output(t, terraformOptions, "firewall_name")
	vpnGwName := terraform.Output(t, terraformOptions, "vpn_gateway_name")
	erGwName := terraform.Output(t, terraformOptions, "express_route_gateway_name")

	// Create Azure clients
	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatal(err)
	}

	ctx := context.Background()

	// Verify Resource Group exists
	exists := azure.ResourceGroupExists(t, rgName, subscriptionID)
	assert.True(t, exists)

	// Check VWAN
	vwanClient, err := armnetwork.NewVirtualWansClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatal(err)
	}

	vwan, err := vwanClient.Get(ctx, rgName, vwanName, nil)
	if err != nil {
		t.Fatal(err)
	}
	assert.NotNil(t, vwan.Properties)

	// Check Virtual Hub
	vhubClient, err := armnetwork.NewVirtualHubsClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatal(err)
	}

	vhub, err := vhubClient.Get(ctx, rgName, vhubName, nil)
	if err != nil {
		t.Fatal(err)
	}
	assert.NotNil(t, vhub.Properties)
	assert.Equal(t, "10.0.0.0/23", *vhub.Properties.AddressPrefix)

	// Check Azure Firewall
	fwClient, err := armnetwork.NewAzureFirewallsClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatal(err)
	}

	fw, err := fwClient.Get(ctx, rgName, fwName, nil)
	if err != nil {
		t.Fatal(err)
	}
	assert.NotNil(t, fw.Properties)
	assert.Equal(t, armnetwork.AzureFirewallSKUTierStandard, fw.Properties.SKU.Tier)

	// Check VPN Gateway
	vpnClient, err := armnetwork.NewVPNGatewaysClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatal(err)
	}

	vpnGw, err := vpnClient.Get(ctx, rgName, vpnGwName, nil)
	if err != nil {
		t.Fatal(err)
	}
	assert.NotNil(t, vpnGw.Properties)
	if vpnGw.Properties.VPNGatewayScaleUnit != nil {
		assert.Equal(t, int32(1), *vpnGw.Properties.VPNGatewayScaleUnit)
	}

	// Check ExpressRoute Gateway
	erClient, err := armnetwork.NewExpressRouteGatewaysClient(subscriptionID, cred, nil)
	if err != nil {
		t.Fatal(err)
	}

	erGw, err := erClient.Get(ctx, rgName, erGwName, nil)
	if err != nil {
		t.Fatal(err)
	}
	assert.NotNil(t, erGw.Properties)
	if erGw.Properties.AutoScaleConfiguration != nil && erGw.Properties.AutoScaleConfiguration.Bounds != nil {
		assert.Equal(t, int32(1), *erGw.Properties.AutoScaleConfiguration.Bounds.Min)
	}
}
