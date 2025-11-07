# -----------------------------
# Resource Group
# -----------------------------
resource "azurerm_resource_group" "rg" {
  name     = "peerisland-rg"
  location = "eastus"
}

# -----------------------------
# Log Analytics Workspace
# -----------------------------
resource "azurerm_log_analytics_workspace" "la" {
  name                = "peerisland-la"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# -----------------------------
# Azure Container Registry (ACR)
# -----------------------------
resource "azurerm_container_registry" "acr" {
  name                = "peerislandacr"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Premium" # ✅ FIX: Premium required for advanced security settings
  admin_enabled       = false

  # ✅ FIX: Deny public network access
  public_network_access_enabled = false

  # ✅ FIX: Enable dedicated data endpoint
  data_endpoint_enabled = true

  # ✅ FIX: Add retention policy for images
  retention_policy {
    days    = 7
    enabled = true
  }

  # ✅ FIX: Enable zone redundancy
  zone_redundancy_enabled = true

  # ✅ FIX: Add geo-replication for DR
  georeplications {
    location                = "eastus2"
    zone_redundancy_enabled = true
  }

  network_rule_set {
    default_action = "Deny"
  }

  lifecycle {
    ignore_changes = [admin_enabled]
  }
}

# -----------------------------
# Azure Kubernetes Service (AKS)
# -----------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "peerisland-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "peerisland-dns"

  default_node_pool {
    name                 = "default"
    node_count           = var.aks_node_count
    vm_size              = "Standard_D2_v3"
    enable_node_public_ip = false
    os_disk_type         = "Managed"
    max_pods             = 50
  }

  identity {
    type = "SystemAssigned"
  }

  azure_active_directory_role_based_access_control {
    managed            = true
    azure_rbac_enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    service_cidr      = "10.0.0.0/16"
    dns_service_ip    = "10.0.0.10"
  }

  sku_tier = "Standard"

  private_cluster_enabled = true

  depends_on = [azurerm_container_registry.acr]
}


# -----------------------------
# AKS Monitoring (Log Analytics)
# -----------------------------
resource "azurerm_monitor_diagnostic_setting" "aks_monitoring" {
  name                       = "aks-monitoring"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.la.id

  log {
    category = "kube-apiserver"
    enabled  = true
  }

  log {
    category = "kube-controller-manager"
    enabled  = true
  }

  log {
    category = "kube-scheduler"
    enabled  = true
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
