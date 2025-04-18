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
- Example pattern:
  ```go
  func TestConnectivityLDZModule(t *testing.T) {
    t.Parallel()
    terraformOptions := &terraform.Options{
      TerraformDir: "..",
      Vars: map[string]interface{}{...}
    }
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

1. Regional deployment validation
2. Cross-region connectivity
3. ExpressRoute integration
4. Global routing patterns

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
