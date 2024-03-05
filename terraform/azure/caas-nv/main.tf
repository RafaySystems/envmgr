data "azurerm_resource_group" "existing" {
  count = var.existing_resource_group_name == null ? 0 : 1
  name  = var.existing_resource_group_name
}

resource "azurerm_resource_group" "aks" {
  count    = var.existing_resource_group_name == null && var.cloud_provider == "azure" ? 1 : 0
  name     = "${var.cluster_name}-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  count               = var.cloud_provider == "azure"  ? 1 : 0
  name                = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.aks[0].name : data.azurerm_resource_group.existing[0].name
  location            = var.existing_resource_group_name == null ? azurerm_resource_group.aks[0].location : data.azurerm_resource_group.existing[0].location
  dns_prefix          = var.cluster_name

  default_node_pool {
    name                = "akscpu"
    node_count          = var.node_pool_config[var.node_pool_size]["cpu_node_count"]
    enable_auto_scaling = true
    min_count           = var.node_pool_config[var.node_pool_size]["cpu_node_pool_min_count"]
    max_count           = var.node_pool_config[var.node_pool_size]["cpu_node_pool_max_count"]
    vm_size             = var.node_pool_config[var.node_pool_size]["cpu_machine_type"]
    os_disk_size_gb     = var.node_pool_config[var.node_pool_size]["cpu_node_pool_disk_size"]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    group      = "aks"
    managed_by = "Terraform"
  }
}

data "azurerm_kubernetes_cluster" "aks" {
  count = var.cloud_provider == "azure"  ? 1 : 0
  name                = azurerm_kubernetes_cluster.aks[0].name
  resource_group_name = var.existing_resource_group_name == null ? azurerm_resource_group.aks[0].name : data.azurerm_resource_group.existing[0].name
  depends_on          = [azurerm_kubernetes_cluster.aks]
}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  count = var.cloud_provider == "azure"  ? 1 : 0
  depends_on            = [azurerm_kubernetes_cluster.aks]
  name                  = "aksgpu1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks[0].id
  node_count            = var.node_pool_config[var.node_pool_size]["gpu_node_count"]
  enable_auto_scaling   = true
  min_count             = var.node_pool_config[var.node_pool_size]["gpu_node_pool_min_count"]
  max_count             = var.node_pool_config[var.node_pool_size]["gpu_node_pool_max_count"]
  vm_size               = var.node_pool_config[var.node_pool_size]["gpu_machine_type"]
  os_disk_size_gb       = var.node_pool_config[var.node_pool_size]["gpu_node_pool_disk_size"]
  tags = {
    group      = "aks"
    managed_by = "Terraform"
  }
}

resource "local_file" "kubeconfig" {
  count = var.cloud_provider == "azure"  ? 1 : 0
  depends_on   = [azurerm_kubernetes_cluster.aks[0]]
  filename     = "./kubeconfig"
  content      = azurerm_kubernetes_cluster.aks[0].kube_config_raw
}

resource "rafay_import_cluster" "aks" {
  count = var.cloud_provider == "azure"  ? 1 : 0
  clustername           = var.cluster_name
  projectname           = var.project_name
  blueprint             = var.aks_blueprint
  blueprint_version     = var.aks_blueprint_version
  kubernetes_provider   = "AKS"
  provision_environment = "CLOUD"
  values_path           = "values.yaml"
  depends_on 	= [azurerm_kubernetes_cluster_node_pool.aks]
  lifecycle {
    ignore_changes = [
      bootstrap_path
    ]
  }
}

resource "helm_release" "rafay_operator" {
  count = var.cloud_provider == "azure"  ? 1 : 0
  name       = "v2-infra"
  namespace = "rafay-system"
  create_namespace = true
  repository = "https://rafaysystems.github.io/rafay-helm-charts/"
  chart      = "v2-infra"

  values = [rafay_import_cluster.aks[0].values_data]
  lifecycle {
    ignore_changes = [
      version
    ]
  }
  depends_on = [local_file.kubeconfig]
}