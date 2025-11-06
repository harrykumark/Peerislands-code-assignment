resource "azurerm_resource_group" "rg" {
name = var.rg_name
location = var.location
}


resource "azurerm_virtual_network" "vnet" {
name = "${var.rg_name}-vnet"
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_subnet" "aks_subnet" {
name = "aks-subnet"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.1.0/24"]
}


resource "azurerm_container_registry" "acr" {
name = var.acr_name
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
sku = "Standard"
admin_enabled = false
}


resource "azurerm_kubernetes_cluster" "aks" {
name = var.aks_name
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
dns_prefix = "${var.rg_name}-aks"


default_node_pool {
name = "agentpool"
node_count = var.node_count
vm_size = "Standard_D2s_v3"
vnet_subnet_id = azurerm_subnet.aks_subnet.id
enable_auto_scaling = true
min_count = 1
max_count = 3
}


identity {
type = "SystemAssigned"
}


role_based_access_control { enabled = true }


network_profile {
network_plugin = "azure"
load_balancer_sku = "standard"
}
}
