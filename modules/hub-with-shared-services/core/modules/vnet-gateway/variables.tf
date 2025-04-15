variable "company_name" {
  description = "The name of the company that owns the hub network."
  type        = string
}

variable "location" {
  description = "The location/region where the hub network will be created."
  type        = string
}

variable "location_code" {
  description = "The location code for the hub network naming."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the hub network will be created."
  type        = string
  default     = null
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
