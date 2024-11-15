output "eks_cluster_name" {
  value = rafay_eks_cluster.ekscluster-basic.cluster[0].metadata[0].name
}
