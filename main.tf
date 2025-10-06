terraform {
  required_version = ">= 0.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals  {
  resource_name       = "tf-${terraform.workspace}-${var.vm_name}"
  resource_nic_name   = "tf-${terraform.workspace}-ch-nic-name2"
  public_ip_name      = "tf-${terraform.workspace}-public-ip"
  security_group_name = "tf-${terraform.workspace}-nsg"
}

## 1.Resource group created in azure already.
## 2. Virtual network and subnet are assumed to be created already.

resource "azurerm_public_ip" "public_ip" {
  name                = local.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-RDP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"   # port RDP
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"     # port SSH
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

data "azurerm_subnet" "existing" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
}

resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                  = data.azurerm_subnet.existing.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

## Create Network Interface Card (NIC)
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

# Create Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  computer_name       = "${local.resource_name}"
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

  settings = <<SETTINGS
{
  "fileUris": [
    "${var.s3_scripts_bucket}"
  ],
  "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File 1-create-environment-variables.ps1"
}
SETTINGS
}