variable "linked_automation_account_creation_enabled" {
  type        = bool
  description = "(Optional) Enable the creation of a linked Automation Account. Defaults to false."
  default     = false
}

variable "automation_account_name" {
  type        = string
  description = "(Optional) The name of the Automation Account."
  default     = null
}

variable "automation_account_encryption" {
  type = object({
    key_vault_key_id          = string
    user_assigned_identity_id = optional(string, null)
  })
  description = "(Optional) The encryption settings for the Automation Account. This is a map of key-value pairs."
  default     = null
}

variable "automation_account_local_authentication_enabled" {
  type        = bool
  description = "(Optional) Enable local authentication for the Automation Account. Defaults to true."
  default     = true
}

variable "automation_account_public_network_access_enabled" {
  type        = bool
  description = "(Optional) Enable public network access for the Automation Account. Defaults to false."
  default     = false
}

variable "automation_account_sku_name" {
  type        = string
  description = "(Optional) The SKU name for the Automation Account. Defaults to 'Basic'."
  default     = "Basic"
}

variable "user_assigned_managed_identities" {
  type = object({
    ama = object({
      enabled  = optional(bool, true)
      name     = string
      location = optional(string, null)
      tags     = optional(map(string), null)
    })
  })
  default = {
    ama = {
      name    = "id-ama-management-prd"
      enabled = false
    }
  }
}
