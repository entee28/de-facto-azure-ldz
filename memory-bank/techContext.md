# Technical Context

## Core Technologies

### 1. Infrastructure as Code

#### Terraform

- Primary IaC tool for resource provisioning
- Version: Latest stable for production use
- State management: Required for each environment
- Backend: To be configured per deployment

#### Azure Verified Modules (AVM)

- Foundation for resource creation
- Strictly versioned dependencies
- Example from VNet Gateway:
  ```hcl
  source  = "Azure/avm-ptn-vnetgateway/azurerm"
  version = "0.6.3"
  ```

### 2. Testing Framework

#### Terratest

- Go-based infrastructure testing
- Supports parallel test execution
- Integration testing capabilities
- Type-safe helper functions
- Comprehensive validation patterns

##### Testing Helper Functions

```go
// Safe type assertion helpers
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

// Resource validation helpers
func assertValidAzureResourceID(t *testing.T, id string, resourceType string) {
    // Validates Azure resource ID format
}

func assertValidCIDR(t *testing.T, cidr string, description string) {
    // Validates network CIDR format
}
```

##### Example Test Pattern

```go
func TestConnectivityLDZModule(t *testing.T) {
    t.Parallel()
    terraformOptions := &terraform.Options{
        TerraformDir: "..",
        Vars: map[string]interface{}{...}
    }

    // Get outputs safely
    outputs := terraform.OutputAll(t, terraformOptions)
    resourceMap := getMapFromOutput(t, outputs["resources"], "resources")

    // Validate resource properties
    id := getStringFromMap(resourceMap, "id")
    assertValidAzureResourceID(t, id, "Resource")

    // Validate network configuration
    cidr := getStringFromMap(resourceMap, "address_space")
    assertValidCIDR(t, cidr, "Network CIDR")
}
```

## Development Environment

### 1. Project Structure

```
.
├── modules/
│   ├── connectivity/              # Traditional hub-spoke
│   │   ├── main.*.tf             # Resource definitions
│   │   ├── variables.*.tf        # Input variables
│   │   ├── locals.tf             # Local variables
│   │   └── test/                # Module tests
│   ├── connectivity-vwan/        # Virtual WAN implementation
│   │   └── core/
│   │       ├── main.*.tf        # VWAN resources
│   │       ├── variables.*.tf   # VWAN variables
│   │       ├── locals.tf        # Local computations
│   │       └── test/           # VWAN tests
│   ├── management/
│   ├── identity/
│   └── resource-organization/
```

### 2. Module Patterns

- Separate variable files per resource type
- Consistent file naming: main.{resource}.tf
- Local variable consolidation
- Test directory per module

## Dependencies

### 1. Azure Provider

- Required for AVM modules
- Version constraints defined in terraform.tf
- Features block configuration

### 2. Core Modules

#### Hub-Spoke Components

- VNet Gateway
- DNS Resolver
- Hub Networking
- Network Security Groups
- Route Tables
- Private DNS Zones

#### VWAN Components

- Virtual WAN
- VWAN Hub
- ExpressRoute Circuit
- VPN Gateway
- Security Policies

### 3. Testing Dependencies

- Go modules for Terratest
- Required test libraries:
  ```go
  "github.com/gruntwork-io/terratest/modules/terraform"
  "github.com/stretchr/testify/assert"
  ```

## Development Workflow

### 1. Module Development

#### Traditional Modules

1. Define variables and locals
2. Implement resource configurations
3. Add test cases
4. Validate with Terratest

#### VWAN Modules

1. Define regional configuration
2. Implement VWAN resources
3. Configure connectivity
4. Test global patterns

### 2. Testing Approach

#### Common Testing

1. Unit tests per module
2. Integration tests for dependencies
3. Parallel test execution
4. Resource cleanup after tests

#### VWAN-Specific Testing

1. Component Validation

   - Virtual WAN and Hub properties
   - Firewall configuration and rules
   - Gateway settings and scaling
   - Network address spaces

2. Resource Validation

   - Azure resource ID format checking
   - Network CIDR validation
   - Tag compliance verification
   - Role and permission validation

3. Integration Testing

   - Cross-region connectivity
   - ExpressRoute circuit integration
   - Global routing patterns
   - Security policy enforcement

4. Error Handling
   - Type-safe output processing
   - Comprehensive error messages
   - Graceful failure handling
   - Clear validation feedback

### 3. Version Control

1. Semantic versioning for modules
2. Clear dependency specifications
3. Version constraints in source blocks

## Tool Configuration

### 1. Terraform

- Required version: Specified in terraform.tf
- Multiple provider configurations

  ```hcl
  provider "azurerm" {
    features {}
    # Hub-spoke configuration
  }

  provider "azurerm" {
    alias = "vwan"
    features {}
    # VWAN-specific configuration
  }
  ```

- Backend setup requirements

### 2. Azure

- Subscription context
- Resource naming patterns
- Tag standardization
- Role assignments

### 3. Testing

- Go environment setup
- Terratest execution
- Test data management
- Cleanup procedures
