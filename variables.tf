variable "subscription_id" {
  description = "Azure subscription ID. If null, ARM_SUBSCRIPTION_ID is used"
  type        = string
  default     = null
}

variable "computer_name" {
  description = "Windows computer name (max 15 chars). If null, it is derived from the VM resource name"
  type        = string
  default     = null

  validation {
    condition     = var.computer_name == null || length(coalesce(var.computer_name, "x")) <= 15
    error_message = "computer_name must be 15 characters or fewer."
  }
}

variable "allowed_source_ip" {
  description = "IP/CIDR allowed to connect via RDP"
  type        = string
  # PLACEHOLDER: 203.0.113.10 is a random documentation IP (TEST-NET-3, not routable).
  # Replace it with your own public IP (e.g. from `curl ifconfig.me`) followed by /32.
  default = "203.0.113.10/32"

  validation {
    condition     = can(cidrhost(var.allowed_source_ip, 0)) && var.allowed_source_ip != "0.0.0.0/0"
    error_message = "allowed_source_ip must be a valid CIDR (e.g. 1.2.3.4/32) and cannot be 0.0.0.0/0."
  }
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id"
  type        = string
}

variable "nic_name" {
  description = "NIC name"
  type        = string
}

variable "vm_name" {
  description = "VM name"
  type        = string
}

variable "vm_size" {
  description = "VM size"
  type        = string
}

variable "admin_username" {
  description = "Admin user"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  sensitive   = true
}

variable "publisher_server" {
  description = "Publisher for the VM image"
}

variable "offer_server" {
  description = "Offer for the VM image"
}

variable "sku_server" {
  description = "Sku for the VM image"
}

variable "version_server" {
  description = "Version for the VM image"
}

variable "scripts_base_url" {
  description = "Base URL of the folder that hosts the scripts/ files (e.g. https://<account>.blob.core.windows.net/<container>)"
  type        = string
}