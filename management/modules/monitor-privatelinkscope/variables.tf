variable "azure_monitor_private_link_scope_name" {
  type        = string
  description = "The name of the Azure Monitor Private Link Scope"
  default     = null
}

variable "company_name" {
  type        = string
  description = "(Required) The name of the company or organization."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
  default     = null
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
}

variable "lock" {
  type = object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
  description = "The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`."
  default     = {}
  nullable    = false
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.kind)
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "tags" {
  type        = map(any)
  description = "The map of tags to be applied to the resource"
  default     = {}
}
