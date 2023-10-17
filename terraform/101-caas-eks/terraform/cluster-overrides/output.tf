output "rafay_cluster_override" {
  value = {
    project       = rafay_cluster_override.override.id
    spec          = rafay_cluster_override.override.spec
  }
  description   = "Rafay Cluster Overrides info"
}
