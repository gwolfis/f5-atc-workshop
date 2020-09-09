terraform {
    required_version = "~> 0.12"
    required_providers {
        azurerm = "~> 2.1.0"
    }
}

provider "azurerm" {
  features {}
  subscription_id = local.setup.azure.subscription_id
  client_id       = local.setup.azure.client_id
  client_secret   = local.setup.azure.client_secret
  tenant_id       = local.setup.azure.tenant_id
}

locals {
  setup = yamldecode(file(var.setupfile))
}

provider "local" {
  version = "~> 1.4"
}

resource "azurerm_resource_group" "rg" {
  name     = "student${local.setup.azure.student_number}-f5-atc-workshop"
  location = local.setup.azure.location
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "student${local.setup.azure.student_number}log"
  sku                 = "PerNode"
  retention_in_days   = 300
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_storage_account" "mystorage" {
  name                     = "student${local.setup.azure.student_number}storage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
      name        = "student${local.setup.azure.student_number}-storage"
      environment = local.setup.azure.environment
      owner       = local.setup.azure.student_number
  }
}