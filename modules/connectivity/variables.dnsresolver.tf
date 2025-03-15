variable "dnsresolver_name" {
  type        = string
  description = "The name of the DNS resolver."
  default     = null
}

variable "dnsresolver_inbound_endpoints" {
  type = map(object({
    name                         = optional(string)
    subnet_name                  = string
    private_ip_allocation_method = optional(string, "Dynamic")
    private_ip_address           = optional(string, null)
  }))
  description = "The inbound endpoints of the DNS resolver."
  default     = {}
}

variable "dnsresolver_outbound_endpoints" {
  type = map(object({
    name        = optional(string)
    subnet_name = string
    forwarding_ruleset = optional(map(object({
      name                                                = optional(string)
      metadata_for_outbound_endpoint_virtual_network_link = optional(map(string), null)
      rules = optional(map(object({
        name                     = optional(string)
        domain_name              = string
        destination_ip_addresses = map(string)
        enabled                  = optional(bool, true)
        metadata                 = optional(map(string), null)
      })))
    })))
  }))
  description = "The outbound endpoints of the DNS resolver."
  default     = {}
}

variable "dnsresolver_tags" {
  type        = map(string)
  description = "The tags of the DNS resolver."
  default     = {}
}
