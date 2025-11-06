variable "azure_subscription_id" {
description = "Azure subscription id"
type = string
}
variable "azure_tenant_id" {
description = "Azure tenant id"
type = string
}
variable "location" {
description = "Azure region"
type = string
default = "eastus"
}
variable "rg_name" {
description = "Resource group name"
type = string
default = "peerisland-rg"
}
variable "node_count" {
description = "AKS initial node count"
type = number
default = 2
}
variable "acr_name" {
description = "ACR name (must be globally unique)"
type = string
}
variable "aks_name" {
description = "AKS cluster name"
type = string
default = "peerisland-aks"
}
