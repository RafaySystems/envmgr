output "rafay_aks_cluster" {
  value = {
    project       = rafay_aks_cluster.cluster.id
    spec          = rafay_aks_cluster.cluster.spec
  }
  description   = "Rafay AKS Cluster info"
}
