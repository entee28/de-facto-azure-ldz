variable "subscription_id" {
  type        = string
  description = "(Required) The subscription ID where the resources will be created."
}

variable "company_name" {
  type        = string
  description = "(Required) The name of the company or organization."
}

variable "location" {
  type        = string
  description = "(Required) Azure region where the resource should be deployed."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The resource group where the resources will be deployed."
  default     = null
}

variable "resource_group_tags" {
  type        = map(string)
  description = "(Optional) Tags to be applied to the resource group."
  default     = {}
}
