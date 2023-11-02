output "rafay_eks_cluster" {
  value = {
    project       = rafay_eks_cluster.cluster.id
  }
  description   = "Rafay EKS Cluster info"
}
