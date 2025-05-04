terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = {
      version = ">= 4.0.0"
      source  = "hashicorp/azurerm"
    }

    alz = {
      source  = "Azure/alz"
      version = "~> 0.17"
    }

    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.2"
    }
  }
}

provider "alz" {
  library_references = [
    {
      path = "platform/alz",
      ref  = "2024.10.1"
    },
    {
      custom_url = "${path.root}/lib"
    }
  ]
}
