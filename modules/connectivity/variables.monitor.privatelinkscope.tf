variable "ampls_deployment_enabled" {
  type        = bool
  description = "Enable the deployment of the Azure Monitor Private Link Scope."
  default     = true
}

variable "ampls_subnet_name" {
  description = "The name of the subnet for the Azure Monitor Private Link Scope."
  type        = string
  default     = null
}

variable "ampls_subnet_address_prefix" {
  description = "The name of the subnet for the Azure Monitor Private Link Scope."
  type        = string
  default     = null
}

variable "ampls_subnet_private_endpoint_network_policies" {
  description = "The network policies for the Azure Monitor Private Link Scope."
  type        = string
  default     = "Disabled"
}

variable "ampls_name" {
  description = "The name of the Azure Monitor Private Link Scope."
  type        = string
  default     = null
}

variable "ampls_tags" {
  description = "The tags to be applied to the Azure Monitor Private Link Scope."
  type        = map(string)
  default     = {}
}

variable "ampls_ingestion_access_mode" {
  type        = string
  description = "The ingestion access mode for the Azure Monitor Private Link Scope"
  default     = "Open"
}

variable "ampls_query_access_mode" {
  type        = string
  description = "The query access mode for the Azure Monitor Private Link Scope"
  default     = "Open"
}