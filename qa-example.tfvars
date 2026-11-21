# Subscription (optional if ARM_SUBSCRIPTION_ID is set)
subscription_id = "Azure subscription ID"

# Network access: only this IP can connect via RDP.
# 203.0.113.10 is a random placeholder IP; replace it with your own public IP.
allowed_source_ip = "203.0.113.10/32"

# Resource Group Variables
resource_group_name = "Name of the resource group"
location            = "Azure region"

# Virtual Network Variables
subnet_id = "Id of the Subnet"
nic_name  = "Name of the Network Interface Card (NIC)"
vm_name   = "Name of the Virtual Machine"
vm_size   = "Size of the VM (e.g., NV series with GPU)"

# System credentials
admin_username = "Administrator username for VM"
admin_password = "Administrator password for VM"

# Server Image Variables
publisher_server = "Publisher of the Windows Server image"
offer_server     = "Offer name (e.g., Windows Server)"
sku_server       = "SKU or edition of the image (e.g., 2022 Datacenter Azure Edition)"
version_server   = "Version of the image (latest or specific)"

# Additional Variables
scripts_base_url = "Base URL of the folder with the scripts (e.g. https://<account>.blob.core.windows.net/<container>)"