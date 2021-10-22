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

# Create Network Interface for Linux VM

resource "azurerm_network_interface" "linux-vm-nic-01" {
  name                          = "linux-vm-nic-01"
  location                      = azurerm_resource_group.tf-kirkr-group.location
  resource_group_name           = azurerm_resource_group.tf-kirkr-group.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vms.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.tf-kirkr-linux-vm-01-public-ip.id
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "tf-kirkr-nsg-asso-01" {
  network_interface_id      = azurerm_network_interface.tf-kirkr-linux-vm-nic-01.id
  network_security_group_id = azurerm_network_security_group.tf-kirkr-linux-vm-01-nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "netapp_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" { value = tls_private_key.netapp_ssh.private_key_pem }

# Create the Virtual Machine
resource "azurerm_linux_virtual_machine" "tf-kirkr-linux-vm-01" {
  name                            = "tf-kirkr-linux-vm-01"
  resource_group_name             = azurerm_resource_group.tf-kirkr-group.name
  location                        = azurerm_resource_group.tf-kirkr-group.location
  size                            = "Standard_D4s_v3"
  admin_username                  = var.username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.tf-kirkr-linux-vm-nic-01.id]

  admin_ssh_key {
    username   = "netapp"
    public_key = tls_private_key.netapp_ssh.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  tags = {
    environment = "Terraform Demo"
  }
}