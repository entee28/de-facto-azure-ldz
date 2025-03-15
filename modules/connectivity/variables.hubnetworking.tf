variable "hub_vnet_name" {
  type        = string
  description = "The name of the hub virtual network."
  default     = null
}

variable "hub_vnet_address_space" {
  type        = string
  description = "The address space of the hub virtual network."
}

variable "hub_subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
    nat_gateway_id   = optional(string)
    nsg_name         = optional(string)
    route_table = optional(object({
      assign_generated_route_table = optional(bool, true)
      name                         = optional(string)
    }))
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
    service_endpoints                          = optional(list(string))
    service_endpoint_policy_ids                = optional(list(string))
    service_endpoint_policy_assignment_enabled = optional(bool, true)
  }))
}

variable "vnet_tags" {
  type        = map(string)
  description = "The tags of the hub virtual network."
  default     = {}
}

//Firewall variables
variable "firewall_name" {
  type        = string
  description = "The name of the firewall."
  default     = null
}

variable "firewall_policy_name" {
  type        = string
  description = "The name of the firewall policy."
  default     = null
}

variable "firewall_subnet_address_prefix" {
  type        = string
  description = "The address prefix of the firewall subnet."
}

variable "firewall_zones" {
  type        = list(string)
  description = "The availability zones of the firewall."
  default     = null
}

variable "firewall_tags" {
  type        = map(string)
  description = "The tags of the firewall."
  default     = {}
}

//Routing variables
variable "route_table_entries_firewall" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = [
    {
      name           = "route-to-internet-default"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

variable "route_table_entries_user_subnets" {
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
  default = []
}
