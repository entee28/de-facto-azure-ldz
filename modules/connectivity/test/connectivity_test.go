package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// type RouteTableEntry struct {
// 	Name             string `mapstructure:"name"`
// 	AddressPrefix    string `mapstructure:"address_prefix"`
// 	NextHopType      string `mapstructure:"next_hop_type"`
// 	NextHopIPAddress string `mapstructure:"next_hop_in_ip_address"`
// }

// type NSGRule struct {
// 	Name                              string   `mapstructure:"name"`
// 	Access                            string   `mapstructure:"access"`
// 	Description                       string   `mapstructure:"description"`
// 	DestinationAddressPrefix          string   `mapstructure:"destination_address_prefix"`
// 	DestinationPortRange              string   `mapstructure:"destination_port_range"`
// 	DestinationAddressPrefixes        []string `mapstructure:"destination_address_prefixes"`
// 	DestinationPortRanges             []string `mapstructure:"destination_port_ranges"`
// 	Direction                         string   `mapstructure:"direction"`
// 	Priority                          int      `mapstructure:"priority"`
// 	Protocol                          string   `mapstructure:"protocol"`
// 	SourceAddressPrefix               string   `mapstructure:"source_address_prefix"`
// 	SourcePortRange                   string   `mapstructure:"source_port_range"`
// 	SourceAddressPrefixes             []string `mapstructure:"source_address_prefixes"`
// 	SourcePortRanges                  []string `mapstructure:"source_port_ranges"`
// 	SourceApplicationSecurityGroupIds []string `mapstructure:"source_application_security_group_ids"`
// }

// type DiagnosticSettings struct {
// 	Name                         string   `mapstructure:"name"`
// 	LogCategories                []string `mapstructure:"log_categories"`
// 	LogGroups                    []string `mapstructure:"log_groups"`
// 	MetricCategories             []string `mapstructure:"metric_categories"`
// 	LogAnalyticsDestinationType  string   `mapstructure:"log_analytics_destination_type"`
// 	LogAnalyticsWorkspaceID      string   `mapstructure:"workspace_resource_id"`
// 	StorageAccountID             string   `mapstructure:"storage_account_resource_id"`
// 	EventHubAuthorizationRuleID  string   `mapstructure:"event_hub_authorization_rule_resource_id"`
// 	EventHubName                 string   `mapstructure:"event_hub_name"`
// 	MarketplacePartnerResourceID string   `mapstructure:"marketplace_partner_resource_id"`
// }

// type ForwardingRule struct {
// 	Name                   string            `mapstructure:"name"`
// 	DomainName             string            `mapstructure:"domain_name"`
// 	DestinationIPAddresses map[string]string `mapstructure:"destination_ip_addresses"`
// 	Enabled                bool              `mapstructure:"enabled"`
// 	Metadata               map[string]string `mapstructure:"metadata"`
// }

// type ForwardingRuleset struct {
// 	Name     string                    `mapstructure:"name"`
// 	Rules    map[string]ForwardingRule `mapstructure:"rules"`
// 	Metadata map[string]string         `mapstructure:"metadata_for_outbound_endpoint_virtual_network_link"`
// }

// type HubSubnet struct {
// 	Name                                   string                 `mapstructure:"name"`
// 	AddressPrefixes                        string                 `mapstructure:"address_prefixes"`
// 	NatGatewayID                           string                 `mapstructure:"nat_gateway_id"`
// 	NSGName                                string                 `mapstructure:"nsg_name"`
// 	RouteTable                             map[string]interface{} `mapstructure:"route_table"`
// 	Delegation                             map[string]interface{} `mapstructure:"delegation"`
// 	ServiceEndpoints                       []string               `mapstructure:"service_endpoints"`
// 	ServiceEndpointsPolicyIDs              []string               `mapstructure:"service_endpoint_policy_ids"`
// 	ServiceEndpointPolicyAssignmentEnabled bool                   `mapstructure:"service_endpoint_policy_assignment_enabled"`
// }

// type UserRouteTable struct {
// 	Name   string                     `mapstructure:"name"`
// 	Routes map[string]RouteTableEntry `mapstructure:"routes"`
// 	Tags   map[string]string          `mapstructure:"tags"`
// }

// type UserNetworkSecurityGroup struct {
// 	Name               string                        `mapstructure:"name"`
// 	SecurityRules      map[string]NSGRule            `mapstructure:"security_rules"`
// 	Tags               map[string]string             `mapstructure:"tags"`
// 	DiagnosticSettings map[string]DiagnosticSettings `mapstructure:"diagnostic_settings"`
// }

// type DNSResolverInboundEndpoint struct {
// 	Name                      string `mapstructure:"name"`
// 	SubnetName                string `mapstructure:"subnet_name"`
// 	PrivateIPAllocationMethod string `mapstructure:"private_ip_allocation_method"`
// 	PrivateIPAddress          string `mapstructure:"private_ip_address"`
// }

// type DNSResolverOutboundEndpoint struct {
// 	Name              string                       `mapstructure:"name"`
// 	SubnetName        string                       `mapstructure:"subnet_name"`
// 	ForwardingRuleset map[string]ForwardingRuleset `mapstructure:"forwarding_ruleset"`
// }

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
