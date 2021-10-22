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

# Provision NFS Volume

# Provision NetApp Account
# resource "azurerm_netapp_account" "dp-anf" {
#  name                = "dp-anf"
#  resource_group_name = azurerm_resource_group.lab-rg.name
#  location            = azurerm_resource_group.lab-rg.location

# Disabled due to test lab already having an AD:
# Error: Error waiting for creation of NetApp Account "dp-anf" (Resource Group "lab-rg"): Code="BadRequest" Message="Only one active directory allowed within the same region. Account core-west-europe in resource group emea-core-west-europe-anf currently has an active directory connection string." Details=[{"code":"TooManyActiveDirectories","message":"Only one active directory allowed within the same region. Account core-west-europe in resource group emea-core-west-europe-anf currently has an active directory connection string."}]

#   active_directory {
#   username            = var.username
#   password            = var.password
#   smb_server_name     = var.smbservername
#   dns_servers         = ["20.0.1.100"]
#   domain              = var.domainname
# }


# Provision Storage Pool
resource "azurerm_netapp_pool" "lab-anf-pool-01" {

name                = "${var.anf_pool_name}"
account_name        = "${var.anf_account_name}"
location            = "${var.region}"
resource_group_name = "${var.pool_resource_group_name}"
service_level       = "${var.anf_pool_ser_lvl}"
size_in_tb          = "${var.anf_vol_size}"

}

resource "azurerm_netapp_volume" "vol-01" {
  #   lifecycle {
  #     prevent_destroy = true
  #   }

  name                = "${var.anf_vol_name}"
  location            = "${var.region}"
  resource_group_name = "${var.pool_resource_group_name}"
  account_name        = "${var.anf_account_name}"
  pool_name           = "${var.anf_pool_name}"
  volume_path         = "nfs01"
  service_level       = "${var.anf_pool_ser_lvl}"
  subnet_id           = "${var.subnet_id}"
  protocols           = ["NFSv3"]
  storage_quota_in_gb = 1000

}

