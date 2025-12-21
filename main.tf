terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
variable "environment" {
  description = "type of environment"
  type        = string
  default     = "staging"
}
locals {
  common_tags = {
    environment = "prod"
    lab = "finance"
  }
}
resource "azurerm_resource_group" "rg" {
  name     = "var.resource_group_name"
  location = "southindia"
  # optional: add tags if you want to manage them in Terraform
  # tags = { env = "Myterraform Getting started" }
}
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "myTFVnet"
  address_space       = ["10.0.0.0/16"]
  location            = "southindia"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_storage_account" "example" {
  name                     = "demotfshanstorage"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = local.common_tags.environment
    lab         = local.common_tags.lab
  }
}