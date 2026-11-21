terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Required since azurerm 4.x. When null, the provider falls back to the
  # ARM_SUBSCRIPTION_ID environment variable.
  subscription_id = var.subscription_id
}

locals {
  resource_name       = "tf-${terraform.workspace}-${var.vm_name}"
  resource_nic_name   = "tf-${terraform.workspace}-nic-name2"
  public_ip_name      = "tf-${terraform.workspace}-public-ip"
  security_group_name = "tf-${terraform.workspace}-nsg"

  # Windows computer names are limited to 15 characters.
  computer_name = coalesce(
    var.computer_name,
    replace(substr(local.resource_name, 0, 15), "/-+$/", "")
  )

  # Scripts downloaded to the VM by the Custom Script Extension.
  # owner-script.ps1 is the entry point and runs the others.
  vm_scripts = [
    "owner-script.ps1",
    "create_environment_variable.ps1",
    "install_script.ps1",
  ]
}

resource "azurerm_public_ip" "public_ip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  # RDP is only allowed from var.allowed_source_ip (not from the whole Internet).
  # SSH (22) was removed: it is not needed on a Windows VM.
  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389" # port RDP
    source_address_prefix      = var.allowed_source_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = local.resource_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  lifecycle {
    ignore_changes = [
      name,
      ip_configuration["name"]
    ]
  }
}

# The NSG is attached to the VM's NIC (not to the shared subnet), so it does not
# replace the NSG of other resources in the subnet or clash between workspaces.
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_windows_virtual_machine" "vm" {
  computer_name       = local.computer_name
  name                = local.resource_name
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password

  source_image_reference {
    publisher = var.publisher_server
    offer     = var.offer_server
    sku       = var.sku_server
    version   = var.version_server
  }

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

resource "azurerm_virtual_machine_extension" "add_environment_variable" {
  name                 = "Install_Scripts"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = jsonencode({
    fileUris = [
      for script in local.vm_scripts : "${trimsuffix(var.scripts_base_url, "/")}/${script}"
    ]
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File owner-script.ps1 -TerraformServerName ${local.resource_name}"
  })
}