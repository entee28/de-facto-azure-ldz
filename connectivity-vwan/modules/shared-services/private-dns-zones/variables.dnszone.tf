variable "private_dns_zones" {
  description = "Map of private DNS zones to create with their configuration"
  type = map(object({
    domain_name                = string
    vnet_link_autoregistration = optional(bool, false)
    a_records = optional(map(object({
      name                = string
      ttl                 = number
      records             = list(string)
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    aaaa_records = optional(map(object({
      name                = string
      ttl                 = number
      records             = list(string)
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    cname_records = optional(map(object({
      name                = string
      ttl                 = number
      record              = string
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    mx_records = optional(map(object({
      name = optional(string, "@")
      ttl  = number
      records = map(object({
        preference = number
        exchange   = string
      }))
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    srv_records = optional(map(object({
      name = string
      ttl  = number
      records = map(object({
        priority = number
        weight   = number
        port     = number
        target   = string
      }))
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    txt_records = optional(map(object({
      name = string
      ttl  = number
      records = map(object({
        value = string
      }))
      resource_group_name = optional(string)
      zone_name           = optional(string)
      tags                = optional(map(string))
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}
