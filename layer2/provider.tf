terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.70.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.41.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "1.8.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {}
