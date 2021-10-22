# Provision public IP for the Windows AD server
resource "azurerm_public_ip" "dp-win-ad-01-public-ip" {
  name                = "dp-linux-win-ad-01-public-ip"
  location            = azurerm_resource_group.lab-rg.location
  resource_group_name = azurerm_resource_group.lab-rg.name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

# Provision and configure the NIC interface for the Windows AD server
resource "azurerm_network_interface" "tf-kirk-win-ad-01-nic-01" {
  name                          = "tf-kirk-win-ad-01-nic-01"
  location                      = azurerm_resource_group.lab-rg.location
  resource_group_name           = azurerm_resource_group.lab-rg.name
  enable_accelerated_networking = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vms.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "20.0.1.100"
    public_ip_address_id          = azurerm_public_ip.dp-win-ad-01-public-ip.id
  }
}

# Create the NSG for the Windows AD server
resource "azurerm_network_security_group" "dp-win-ad-01-nsg" {
  name                = "dp-win-ad-01-nsg"
  location            = azurerm_resource_group.lab-rg.location
  resource_group_name = azurerm_resource_group.lab-rg.name

  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Terraform Demo"
  }
}

# Provision the Windows AD server VM
resource "azurerm_windows_virtual_machine" "dp-win-ad-01" {
  name                = "ad01"
  resource_group_name = azurerm_resource_group.lab-rg.name
  location            = azurerm_resource_group.lab-rg.location
  size                = "Standard_D4s_v3"
  admin_username      = var.username
  admin_password      = var.password
  network_interface_ids = [
    azurerm_network_interface.tf-kirk-win-ad-01-nic-01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# TODO output "azurerm_windows_virtual_machine" { value = azurerm_windows_virtual_machine.dp-win-ad-01.private_key_pem }

# Connect the security group to the network interface (Enable RDP connectivity)
resource "azurerm_network_interface_security_group_association" "dp-nsg-asso-02" {
  network_interface_id      = azurerm_network_interface.tf-kirk-win-ad-01-nic-01.id
  network_security_group_id = azurerm_network_security_group.dp-win-ad-01-nsg.id
}

# TODO - Configure AD role and services
// the `exit_code_hack` is to keep the VM Extension resource happy
# locals { 
#   import_command       = "Import-Module ADDSDeployment"
#   password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
#   install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
#   configure_ad_command = "Install-ADDSForest -CreateDnsDelegation:$false -DomainMode Win2012R2 -DomainName ${var.active_directory_domain} -DomainNetbiosName ${var.active_directory_netbios_name} -ForestMode Win2012R2 -InstallDns:$true -SafeModeAdministratorPassword $password -Force:$true"
#   shutdown_command     = "shutdown -r -t 10"
#   exit_code_hack       = "exit 0"
#   powershell_command   = "${local.import_command}; ${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
# }

resource "azurerm_virtual_machine_extension" "dp-win-ad-01-ext-install-ad" {
  name                 = azurerm_windows_virtual_machine.dp-win-ad-01.name
  virtual_machine_id   = azurerm_windows_virtual_machine.dp-win-ad-01.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  protected_settings = <<PROTECTED_SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"Import-Module ADDSDeployment, ActiveDirectory; $password = ConvertTo-SecureString ${var.password} -AsPlainText -Force; Add-WindowsFeature -name ad-domain-services -IncludeManagementTools; Install-ADDSForest -DomainName ${var.domainname} -SafeModeAdministratorPassword $password -Force:$true; shutdown -r -t 10; exit 0\""
    }
PROTECTED_SETTINGS

  tags = {
    environment = "Production"
  }

  depends_on = [
    azurerm_windows_virtual_machine.dp-win-ad-01
  ]
}