variable "company_name" {
  description = "The name of the company that owns the hub network."
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
