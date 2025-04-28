variable "company_name" {
  description = "The name of the company that owns the private DNS zones."
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID where the resource will be created."
  type        = string
}

variable "location" {
  description = "The location/region where the private DNS zones will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the private DNS zones will be created."
  type        = string
  default     = null
}

variable "shared_services_virtual_network_name" {
  description = "The name of the shared services virtual network."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod') used in resource naming."
  type        = string
  default     = "prd"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
