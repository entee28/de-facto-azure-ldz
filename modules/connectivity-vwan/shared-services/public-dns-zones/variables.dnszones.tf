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
