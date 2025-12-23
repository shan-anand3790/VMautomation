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
variable "prefix" {
  default = "tfvmex"
}
variable "environment" {
  description = "type of environment"
  type        = string
  default     = "staging"
}# These act as placeholders for the data coming from your file
variable "os_disk_config" {
  description = "Configuration for the OS Disk"
  type        = map(string)
}

variable "image_reference" {
  description = "Configuration for the Source Image"
  type        = map(string)
}
# ---------------------
# Create a resource group
#resource "azurerm_resource_group" "rg" {
  #name     = "${var.prefix}-rg"
 # location = "southindia"
  # optional: add tags if you want to manage them in Terraform
  # tags = { env = "Myterraform Getting started" }
#}
# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    environment = var.environment
    name        = "${var.prefix}-vm"
  }
}
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = var.os_disk_config["name"]
    caching           = var.os_disk_config["caching"]
    create_option     = var.os_disk_config["create_option"]
    managed_disk_type = var.os_disk_config["managed_disk_type"]
  }
  storage_image_reference {
    publisher = var.image_reference["publisher"]
    offer     = var.image_reference["offer"]
    sku       = var.image_reference["sku"]
    version   = var.image_reference["version"]
  }
   os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234"
  }
   os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = var.environment
    name        = "${var.prefix}-vm"
 }

} 
# Output the Private IP Address
output "vm_private_ip" {
  value = azurerm_network_interface.main.private_ip_address
}

# Output the OS Disk Name
output "os_disk_name" {
  value = azurerm_virtual_machine.main.storage_os_disk[0].name
}

# Output the Resource Group Name
output "resource_group" {
  value = azurerm_resource_group.rg.name
}



