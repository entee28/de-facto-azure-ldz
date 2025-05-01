variable "firewall_policy_rule_collection_group_firewall_policy_id" {
  description = "The ID of the firewall policy to which the rule collection group belongs."
  type        = string
}

variable "rcg_emergency_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the emergency rule collection group."
  default     = []
}

variable "rcg_emergency_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the emergency rule collection group."
  default     = []
}

variable "rcg_emergency_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the emergency rule collection group."
  default     = []
}

variable "rcg_common_internet_prd_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the common internet prd rule collection group."
  default     = []
}

variable "rcg_common_internet_prd_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the common internet prd rule collection group."
  default     = []
}

variable "rcg_common_internet_prd_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the common internet prd rule collection group."
  default     = []
}

variable "rcg_common_internal_prd_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the common internal prd rule collection group."
  default     = []
}

variable "rcg_common_internal_prd_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the common internal prd rule collection group."
  default     = []
}

variable "rcg_common_internal_prd_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the common internal prd rule collection group."
  default     = []
}

variable "rcg_common_internet_stg_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the common internet stg rule collection group."
  default     = []
}

variable "rcg_common_internet_stg_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the common internet stg rule collection group."
  default     = []
}

variable "rcg_common_internet_stg_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the common internet stg rule collection group."
  default     = []
}

variable "rcg_common_internal_stg_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the common internal stg rule collection group."
  default     = []
}

variable "rcg_common_internal_stg_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the common internal stg rule collection group."
  default     = []
}

variable "rcg_common_internal_stg_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the common internal stg rule collection group."
  default     = []
}

variable "rcg_base_application_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdn_tags = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_urls      = optional(list(string), [])
      name                  = string
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
      terminate_tls         = optional(bool)
      web_categories        = optional(list(string), [])
      http_headers = optional(list(object({
        name  = string
        value = string
      })))
      protocols = optional(list(object({
        port = number
        type = string
      })))
    }))
  }))
  description = "The application rule collection for the base rule collection group."
  default     = []
}

variable "rcg_base_network_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description           = optional(string)
      destination_addresses = optional(list(string), [])
      destination_fqdns     = optional(list(string), [])
      destination_ip_groups = optional(list(string), [])
      destination_ports     = list(string)
      name                  = string
      protocols             = list(string)
      source_addresses      = optional(list(string), [])
      source_ip_groups      = optional(list(string), [])
    }))
  }))
  description = "The network rule collection for the base rule collection group."
  default     = []
}

variable "rcg_base_nat_rule_collection" {
  type = list(object({
    action   = string
    name     = string
    priority = number
    rule = list(object({
      description         = optional(string)
      destination_address = optional(string)
      destination_ports   = optional(list(string), [])
      name                = string
      protocols           = list(string)
      source_addresses    = optional(list(string), [])
      source_ip_groups    = optional(list(string), [])
      translated_address  = optional(string)
      translated_fqdn     = optional(string)
      translated_port     = number
    }))
  }))
  description = "The NAT rule collection for the base rule collection group."
  default     = []
}
