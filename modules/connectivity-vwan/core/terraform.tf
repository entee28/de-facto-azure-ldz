terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = {
      version = ">= 4.0.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}
