variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_name" {
  description = "VNet name"
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
