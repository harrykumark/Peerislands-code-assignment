variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "peerisland"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Resource Group"
  type        = string
  default     = "peerisland-rg"
}

variable "acr_sku" {
  description = "ACR SKU"
  type        = string
  default     = "Standard"
}

variable "aks_node_count" {
  description = "Number of nodes in AKS"
  type        = number
  default     = 3
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "allowed_aks_ips" {
  description = "List of authorized IP ranges for AKS API server"
  type        = list(string)
  default     = ["<YOUR_IP>/32"] # Replace with your IP
}
