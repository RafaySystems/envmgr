output "clusterId" {
  value = rafay_eks_cluster.eks-cluster.id
}

output "cluster" {
  value = rafay_eks_cluster.eks-cluster.cluster[0].metadata[0].name
}

output "project" {
  value = rafay_eks_cluster.eks-cluster.cluster[0].metadata[0].name
}
