terraform {
  required_version = ">= 0.12.0"
  required_providers {
    azurerm = {
      version = ">= 4.0.0"
      source  = "hashicorp/azurerm"
    }
  }

  backend "azurerm" {
    container_name       = "stb-platform"
    key                  = "management/terraform.tfstate"
    storage_account_name = "ststbcloudopsprd998"
    resource_group_name  = "rg-stb-platform-cloudops-prd-sea-001"
    subscription_id      = "e799f190-b710-4b4f-807a-2a2ad232d4b4"
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.subscription_id
}
