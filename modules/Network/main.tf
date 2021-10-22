# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.37"
    }
  }
}

provider "azurerm" {
  features {}
}

# Core Azure Network resources/configuration

resource "azurerm_virtual_network" "my-vnet" {
  name                = "my-vnet"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.region}"
  address_space       = ["20.0.0.0/16"]
}

resource "azurerm_subnet" "vms" {
  name                 = "vms"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = ["20.0.1.0/24"]
}

resource "azurerm_subnet" "anf" {
  name                 = "anf"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = azurerm_virtual_network.my-vnet.name
  address_prefixes     = ["20.0.2.0/24"]

  delegation {
    name = "anfdelegation"

    service_delegation {
      name = "Microsoft.Netapp/volumes"
    }
  }
}

output "subnet_id" {
  value = azurerm_subnet.anf.id
}


