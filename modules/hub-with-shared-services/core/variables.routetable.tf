variable "user_route_tables" {
  type = map(object({
    name = string
    routes = optional(map(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), {})
    tags = optional(map(string), {})
  }))
  description = "The user route tables to be created."
  default     = {}
}
