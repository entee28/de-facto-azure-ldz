package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Helper functions for safe type assertions and validations
func getMapFromOutput(t *testing.T, output interface{}, key string) map[string]interface{} {
	value, ok := output.(map[string]interface{})
	assert.True(t, ok, fmt.Sprintf("Failed to parse %s as map", key))
	return value
}

func getStringFromMap(t *testing.T, m map[string]interface{}, key string) string {
	value, ok := m[key].(string)
	assert.True(t, ok, fmt.Sprintf("Failed to parse %s as string", key))
	assert.NotEmpty(t, value, fmt.Sprintf("%s should not be empty", key))
	return value
}

func getStringArrayFromMap(t *testing.T, m map[string]interface{}, key string) []string {
	valueRaw, ok := m[key].([]interface{})
	assert.True(t, ok, fmt.Sprintf("Failed to parse %s as array", key))

	result := make([]string, len(valueRaw))
	for i, v := range valueRaw {
		strValue, ok := v.(string)
		assert.True(t, ok, fmt.Sprintf("Failed to parse item %d in %s as string", i, key))
		result[i] = strValue
	}
	return result
}

// Helper function to validate Azure resource IDs safely
func assertValidAzureResourceID(t *testing.T, id string, resourceType string) {
	// Check for empty ID
	if len(id) == 0 {
		t.Errorf("%s ID should not be empty", resourceType)
		return
	}

	// Check subscription prefix safely
	prefix := "/subscriptions/"
	if len(id) < len(prefix) {
		t.Errorf("%s ID too short, should start with %s", resourceType, prefix)
		return
	}

	// Check subscription prefix
	if id[:len(prefix)] != prefix {
		t.Errorf("%s ID should start with %s, got: %s", resourceType, prefix, id)
		return
	}

	// Check provider path
	assert.Contains(t, id, "/providers/Microsoft.",
		fmt.Sprintf("%s ID should contain a valid provider path, got: %s", resourceType, id))
}

// Helper function to check cidr format
func assertValidCIDR(t *testing.T, cidr string, description string) {
	// Check basic CIDR format
	assert.Regexp(t, `^([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}$`, cidr,
		fmt.Sprintf("%s should be in valid CIDR format, got: %s", description, cidr))
}

func TestConnectivityVwan(t *testing.T) {
	t.Parallel()

	subscriptionID := "e799f190-b710-4b4f-807a-2a2ad232d4b4"
	companyName := "contoso"
	locationCode := "sea" // based on locals.region_codes.tf mapping
	environment := "prd"  // based on locals.tf

	nameSuffix := fmt.Sprintf("connectivity-%s-%s", environment, locationCode)
	expectedRgName := fmt.Sprintf("rg-%s-platform-%s-001", companyName, nameSuffix)
	expectedVHubName := fmt.Sprintf("vhub-platform-%s-001", nameSuffix)
	expectedFirewallName := fmt.Sprintf("fw-%s-001", nameSuffix)
	expectedErGatewayName := fmt.Sprintf("ergw-%s-001", nameSuffix)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
		Vars: map[string]interface{}{
			// Core variables
			"subscription_id": subscriptionID,
			"company_name":    "contoso",
			"location":        "southeastasia",
			"hub_resource_group_tags": map[string]interface{}{
				"environment": "test",
				"managed_by":  "terratest",
			},

			// Resource group variables
			"connectivity_sidecar_resourcegroups": map[string]interface{}{
				"shared": map[string]interface{}{
					"name": "rg-stb-platform-shared-prd-sea-001",
					"tags": map[string]interface{}{
						"environment": "test",
						"managed_by":  "terratest",
					},
					"lock": map[string]interface{}{
						"kind": "CanNotDelete",
						"name": "lock",
					},
				},
			},

			// Sidecar VNet variables
			"sidecar_vnets": map[string]interface{}{
				"sidecar-vnet": map[string]interface{}{
					"name":                "vnet-platform-shared-prd-sea-001",
					"address_space":       []string{"172.22.2.0/23"},
					"resource_group_name": "rg-stb-platform-shared-prd-sea-001",
					"subnets": map[string]interface{}{
						"jump": map[string]interface{}{
							"name":             "snet-jump-prd-sea-001",
							"address_prefixes": []string{"172.22.2.64/28"},
						},
					},
					"tags": map[string]interface{}{
						"environment": "test",
						"managed_by":  "terratest",
					},
				},
			},

			// VWAN Components
			"virtual_hub": map[string]interface{}{
				"address_prefix": "172.22.0.0/23",
			},
			"virtual_wan_tags": map[string]interface{}{
				"environment": "test",
				"managed_by":  "terratest",
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

	// Get all outputs
	outputs := terraform.OutputAll(t, terraformOptions)

	// Test resource group naming and configuration
	t.Run("resource_group_naming", func(t *testing.T) {
		resourceGroups := getMapFromOutput(t, outputs["resource_groups"], "resource_groups")
		hubRg := getMapFromOutput(t, resourceGroups["hub"], "hub resource group")
		name := getStringFromMap(t, hubRg, "name")
		assert.Equal(t, expectedRgName, name, "Hub resource group name should match expected default name")
	})

	// Test Virtual WAN and Hub configuration
	t.Run("vwan_hub_config", func(t *testing.T) {
		vwan := getMapFromOutput(t, outputs["virtual_wan"], "virtual_wan")

		// Check Virtual WAN ID and configuration
		id := getStringFromMap(t, vwan, "id")
		assertValidAzureResourceID(t, id, "Virtual WAN")

		// Validate tags
		tags := getMapFromOutput(t, vwan["tags"], "virtual wan tags")
		assert.Equal(t, "test", tags["environment"], "Virtual WAN should have correct environment tag")
		assert.Equal(t, "terratest", tags["managed_by"], "Virtual WAN should have correct managed_by tag")

		// Check Virtual Hub
		hubName := getStringFromMap(t, vwan, "virtual_hub_name")
		hubId := getStringFromMap(t, vwan, "virtual_hub_id")
		assert.Equal(t, expectedVHubName, hubName, "Virtual Hub name should match expected default name")
		assertValidAzureResourceID(t, hubId, "Virtual Hub")

		// Check Virtual Hub address space
		hubAddress := getStringFromMap(t, vwan, "virtual_hub_address_prefix")
		assertValidCIDR(t, hubAddress, "Virtual Hub address prefix")
		assert.Equal(t, "172.22.0.0/23", hubAddress, "Virtual Hub should have correct address space")

		// Check Firewall
		fwName := getStringFromMap(t, vwan, "firewall_name")
		fwId := getStringFromMap(t, vwan, "firewall_id")
		assert.Equal(t, expectedFirewallName, fwName, "Firewall name should match expected default name")
		assertValidAzureResourceID(t, fwId, "Firewall")

		// Check Firewall SKU
		fwSku := getStringFromMap(t, vwan, "firewall_sku_tier")
		assert.Equal(t, "Premium", fwSku, "Firewall should have Premium SKU")

		// Check Firewall IP and connectivity
		fwIP := getStringFromMap(t, vwan, "firewall_private_ip_address")
		assert.NotEmpty(t, fwIP, "Firewall should have a private IP address")
		assert.Regexp(t, `^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$`, fwIP, "Firewall IP should be a valid IPv4 address")
	})

	// Test sidecar VNet connections
	t.Run("sidecar_vnet_connections", func(t *testing.T) {
		vnetsMap := getMapFromOutput(t, outputs["sidecar_virtual_networks"], "sidecar_virtual_networks")

		// Check each VNet
		for _, vnetRaw := range vnetsMap {
			vnet := getMapFromOutput(t, vnetRaw, "vnet")

			// Basic VNet properties
			id := getStringFromMap(t, vnet, "id")
			assertValidAzureResourceID(t, id, "VNet")
			name := getStringFromMap(t, vnet, "name")
			assert.Contains(t, name, "vnet-platform-shared", "Sidecar VNet name should follow naming convention")

			// Check subnets configuration
			subnets := getMapFromOutput(t, vnet["subnets"], "subnets")
			jumpSubnet := getMapFromOutput(t, subnets["jump"], "jump subnet")

			// Validate specific subnet configuration
			assert.Equal(t, "snet-jump-prd-sea-001", getStringFromMap(t, jumpSubnet, "name"), "Jump subnet should have correct name")
			addressPrefixes := getStringArrayFromMap(t, jumpSubnet, "address_prefixes")
			for _, prefix := range addressPrefixes {
				assertValidCIDR(t, prefix, "Subnet address prefix")
			}
			assert.Equal(t, []string{"172.22.2.64/28"}, addressPrefixes, "Jump subnet should have correct address space")

			// Check VNet address space
			addressSpace := getStringArrayFromMap(t, vnet, "address_space")
			for _, cidr := range addressSpace {
				assertValidCIDR(t, cidr, "VNet address space")
			}
			assert.Contains(t, addressSpace, "172.22.2.0/23", "VNet should have correct address space")

			// Check VNet location
			location := getStringFromMap(t, vnet, "location")
			assert.Equal(t, "southeastasia", location, "VNet should be in the correct region")

			// Verify parent ID and tags
			parentId := getStringFromMap(t, vnet, "parent_id")
			assert.NotEmpty(t, parentId, "VNet should have a parent resource group")

			tags := getMapFromOutput(t, vnet["tags"], "vnet tags")
			assert.Equal(t, "test", tags["environment"], "VNet should have correct environment tag")
			assert.Equal(t, "terratest", tags["managed_by"], "VNet should have correct managed_by tag")
		}
	})

	// Test Express Route Gateway configuration
	t.Run("er_gateway_config", func(t *testing.T) {
		vwan := getMapFromOutput(t, outputs["virtual_wan"], "virtual_wan")

		// Check gateway name and ID
		gatewayName := getStringFromMap(t, vwan, "vpn_gateway_name")
		gatewayId := getStringFromMap(t, vwan, "vpn_gateway_id")

		assert.Equal(t, expectedErGatewayName, gatewayName, "Express Route Gateway name should match expected default name")
		assertValidAzureResourceID(t, gatewayId, "Express Route Gateway")

		// Validate gateway configuration
		gwScale := getStringFromMap(t, vwan, "vpn_gateway_scale_unit")
		assert.Equal(t, "1", gwScale, "Gateway should have correct scale unit")
	})
}
