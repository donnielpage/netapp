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

# Core Azure Resource Group/configuration

resource "azurerm_resource_group" "lab-rg" {
  name     = "${var.resource_group_name}"
  location = "${var.region}"
  tags = {
    "creator"   = "dpage"
    "owner"     = "dpage"
    "keepalive" = "Yes"
  }
}

output "name" {
  value = azurerm_resource_group.lab-rg.name
}

output "location" {
   value = azurerm_resource_group.lab-rg.location
}