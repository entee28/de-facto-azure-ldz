variable "monitor_private_link_scope_resource_id" {
  description = "The resource ID of the Azure Monitor Private Link Scope"
  type        = string
}

variable "service_resource_id" {
  description = "The resource ID of the service to be linked to the Azure Monitor Private Link Scope"
  type        = string
}
