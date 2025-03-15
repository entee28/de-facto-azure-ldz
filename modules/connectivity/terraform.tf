terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = {
      version = "~> 4.22.0"
      source  = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {}
}
