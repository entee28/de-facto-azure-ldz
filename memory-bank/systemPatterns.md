# System Patterns

## Core Architecture

```mermaid
graph TD
    subgraph Modules
        M[Management]
        subgraph Connectivity
          C1[Hub-Spoke]
          C2[VWAN]
        end
        I[Identity]
        R[Resource Organization]
    end

    subgraph Foundation
        AVM[Azure Verified Modules]
        Native[Native Azure Resources]
    end

    C1 --> AVM
    C2 --> Native
    M --> AVM
    I --> AVM
    R --> AVM
    Client[Customer Environment] --> Modules
```

## Design Patterns

### 1. Module Architecture

- **AVM-First Design**: Built on Azure Verified Modules for core resource provisioning
- **Layer Separation**: Clear separation between AVM foundation and custom logic
- **Interface Contracts**: Well-defined input/output specifications per module
- **Version Control**: Explicit module versioning and dependency management

### 2. Network Design

The project supports two primary network architectures:

#### Hub-Spoke Architecture

- **Traditional Hub Design**

  - Centralized hub VNet
  - DNS resolution services
  - Shared services placement
  - Cross-network connectivity

- **Security Patterns**
  - Network security groups with standardized rules
  - Route tables for traffic control
  - Private DNS zones for internal resolution

#### Virtual WAN Architecture

- **Global Network Design**

  - Regional VWAN hubs
  - ExpressRoute integration
  - Global transit connectivity
  - Built-in security services

- **Deployment Patterns**
  - Regional resource groups
  - Hub-specific configurations
  - Cross-region connectivity

### 3. Resource Management

```mermaid
graph LR
    subgraph Traditional Hub
        VNG[VNet Gateway]
        DNS[DNS Resolver]
        RT[Route Tables]
        NSG[Network Security Groups]
    end

    subgraph VWAN Hub
        VWAN[Virtual WAN]
        ER[ExpressRoute]
        VPN[VPN Gateway]
    end

    subgraph Shared Services
        MON[Monitoring]
        BAS[Bastion Host]
    end

    VNG --> RT
    DNS --> RT
    RT --> MON
    NSG --> BAS
    NSG --> MON

    VWAN --> ER
    VWAN --> VPN
    ER --> MON
    VPN --> MON
```

## Implementation Paths

### 1. Connectivity Module

Current implementation shows:

- VNet Gateway with configurable options
- Custom route table creation
- Integration with hub networking
- Support for both public and private IP configurations

### 2. Testing Strategy

Based on connectivity_test.go:

- Terratest for infrastructure validation
- Parallel test execution
- Subnet configuration validation
- Resource dependency testing

## Component Relationships

### Module Dependencies

```mermaid
graph TD
    subgraph Hub-Spoke
        HUB[Hub Networking] --> GW[VNet Gateway]
        HUB --> DNS[DNS Resolver]
        HUB --> RT[Route Tables]
        GW --> RT
        DNS --> RT
    end

    subgraph VWAN
        VHUB[VWAN Hub] --> ERC[ExpressRoute Circuit]
        VHUB --> VPNG[VPN Gateway]
        VHUB --> SECP[Security Policies]
    end
```

### Resource Flow

1. **Base Infrastructure**

   - Resource groups
   - Core networking
   - Security components

2. **Connectivity Layer**

   - VNet Gateway deployment
   - DNS resolver configuration
   - Route table association

3. **Service Integration**
   - Private endpoints
   - Monitoring integration
   - Security services

## Design Decisions

1. **Modular Composition**

   - Independent module deployment
   - Network pattern isolation (Hub-Spoke vs VWAN)
   - Minimal cross-module dependencies
   - Clear interface boundaries

2. **Configuration Management**

   - Variable-driven customization
   - Regional configuration patterns
   - Default value patterns
   - Override capabilities

3. **Security Integration**
   - Network segmentation
   - Access control patterns
   - Monitoring integration
   - Global security policies
