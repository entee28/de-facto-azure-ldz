variable "ingestion_access_mode" {
  type        = string
  description = "The ingestion access mode for the Azure Monitor Private Link Scope"
  default     = "Open"
}

variable "query_access_mode" {
  type        = string
  description = "The query access mode for the Azure Monitor Private Link Scope"
  default     = "Open"
}

variable "private_endpoint" {
  type = map(object({
    name                          = optional(string, null),
    private_dns_zone_group_name   = optional(string, "default")
    private_dns_zone_resource_ids = optional(set(string), [])
    network_interface_name        = optional(string, null)
    subnet_id                     = string
    tags                          = optional(map(any), null)
  }))
}
