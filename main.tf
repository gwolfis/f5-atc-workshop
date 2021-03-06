terraform {
    required_version = "~> 0.12"
    required_providers {
        azurerm = "~> 2.1.0"
    }
}

provider "azurerm" {
  features {}
  subscription_id = local.tmp.subscription_id
  client_id       = local.tmp.client_id
  client_secret   = local.tmp.client_secret
  tenant_id       = local.tmp.tenant_id
}

locals {
  setup = yamldecode(file(var.setupfile))
  tmp = yamldecode(file(var.tmpfile))
}

provider "local" {
  version = "~> 1.4"
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "student${local.setup.azure.student_number}f5atcworkshoplog"
  sku                 = "PerNode"
  retention_in_days   = 300
  resource_group_name = local.setup.azure.resource_group
  location            = local.setup.azure.location
}

resource "azurerm_storage_account" "mystorage" {
  name                     = "student${local.setup.azure.student_number}f5atcstorage"
  resource_group_name      = local.setup.azure.resource_group
  location                 = local.setup.azure.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
      name        = "student${local.setup.azure.student_number}-storage"
      environment = local.setup.azure.environment
      owner       = local.setup.azure.student_number
  }
}