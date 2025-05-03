variable "log_analytics_workspace_name" {
  type        = string
  description = "(Optional) The name of the Log Analytics Workspace."
  default     = null
}

variable "log_analytics_solution_plans" {
  type = list(object({
    product   = string
    publisher = optional(string, "Microsoft")
  }))
  description = "(Optional) A list of log analytics solution plans. Each plan is a map with keys 'product' and 'publisher'."
  default = [
    {
      "product" : "OMSGallery/ContainerInsights",
      "publisher" : "Microsoft"
    },
    {
      "product" : "OMSGallery/VMInsights",
      "publisher" : "Microsoft"
    }
  ]
}

variable "log_analytics_workspace_cmk_for_query_forced" {
  type        = bool
  description = "(Optional) Whether or not to force the use of customer-managed keys for query in the Log Analytics Workspace."
  default     = null
}

variable "log_analytics_workspace_daily_quota_gb" {
  type        = number
  description = "(Optional) The daily quota in GB for the Log Analytics Workspace."
  default     = null
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  type        = bool
  description = "(Optional) Whether or not to enable internet ingestion for the Log Analytics Workspace."
  default     = true
}

variable "log_analytics_workspace_internet_query_enabled" {
  type        = bool
  description = "(Optional) Whether or not to enable internet query for the Log Analytics Workspace."
  default     = true
}

variable "log_analytics_workspace_local_authentication_disabled" {
  type        = bool
  description = "(Optional) Whether or not to disable local authentication for the Log Analytics Workspace."
  default     = false
}

variable "log_analytics_workspace_reservation_capacity_in_gb_per_day" {
  type        = number
  description = "(Optional) The reservation capacity in GB per day for the Log Analytics Workspace."
  default     = null
}

variable "log_analytics_workspace_retention_in_days" {
  type        = number
  description = "(Optional) The retention period in days for the Log Analytics Workspace."
  default     = 30
}

variable "log_analytics_workspace_sku" {
  type        = string
  description = "(Optional) The SKU for the Log Analytics Workspace."
  default     = "PerGB2018"
}
