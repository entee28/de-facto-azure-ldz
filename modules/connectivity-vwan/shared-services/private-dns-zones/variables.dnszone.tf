variable "private_dns_zones" {
  description = "Map of private DNS zones to create with their configuration"
  type = map(object({
    domain_name                    = string
    vnet_link_registration_enabled = optional(bool, false)
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
