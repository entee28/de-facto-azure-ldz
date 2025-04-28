# Common variables for resource naming and tagging
variable "company_name" {
  description = "The name of the company that owns the resource."
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID where the resource will be created."
  type        = string
}

variable "location" {
  description = "The location/region where the resource will be created."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod') used in resource naming."
  type        = string
  default     = "prd"
}

variable "resource_group_name" {
  description = "The name of the resource group where the custom private DNS zones will be created. If not provided, a default name will be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "resource_group_tags" {
  description = "Additional tags for the resource group"
  type        = map(string)
  default     = {}
}

variable "shared_services_virtual_network_name" {
  description = "The name of the virtual network to link with the private DNS zones."
  type        = string
}
