# Common variables for resource naming and tagging
variable "company_name" {
  description = "The name of the company that owns the resource."
  type        = string
}

variable "location" {
  description = "The location/region where the resource will be created."
  type        = string
}

variable "location_code" {
  description = "The location code for the resource naming (e.g., 'eus' for East US)."
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., 'dev', 'prod') used in resource naming."
  type        = string
  default     = "prd"
}

variable "resource_group_name" {
  description = "The name of the resource group where the public DNS zones will be created. If not provided, a default name will be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

# Public DNS Zones specific variables
variable "public_dns_zones" {
  description = "Map of public DNS zones to create with their configuration"
  type = map(object({
    name = string
    a_records = optional(map(object({
      name    = string
      ttl     = number
      records = list(string)
    })), {})
    aaaa_records = optional(map(object({
      name    = string
      ttl     = number
      records = list(string)
    })), {})
    cname_records = optional(map(object({
      name   = string
      ttl    = number
      record = string
    })), {})
    mx_records = optional(map(object({
      name = string
      ttl  = number
      records = list(object({
        preference = number
        exchange   = string
      }))
    })), {})
    ns_records = optional(map(object({
      name    = string
      ttl     = number
      records = list(string)
    })), {})
    ptr_records = optional(map(object({
      name    = string
      ttl     = number
      records = list(string)
    })), {})
    srv_records = optional(map(object({
      name = string
      ttl  = number
      records = list(object({
        priority = number
        weight   = number
        port     = number
        target   = string
      }))
    })), {})
    txt_records = optional(map(object({
      name    = string
      ttl     = number
      records = list(list(string))
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "resource_group_tags" {
  description = "Additional tags for the resource group"
  type        = map(string)
  default     = {}
}
