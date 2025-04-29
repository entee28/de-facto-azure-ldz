variable "name" {
  type        = string
  description = "The name of the DNS resolver."
  default     = null
}

variable "virtual_network_resource_id" {
  type        = string
  description = "The resource ID of the virtual network where the DNS resolver will be created."
  default     = null
}

variable "inbound_endpoints" {
  type = map(object({
    name                         = optional(string)
    subnet_name                  = string
    private_ip_allocation_method = optional(string, "Dynamic")
    private_ip_address           = optional(string, null)
  }))
  description = "The inbound endpoints of the DNS resolver."
  default     = {}
}

variable "outbound_endpoints" {
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

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  description = "The role assignments to be created on the private DNS resolver."
  default     = {}
}
