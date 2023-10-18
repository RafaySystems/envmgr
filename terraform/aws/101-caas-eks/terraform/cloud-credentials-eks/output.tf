output "rafay_cloud_credential" {
  value = {
    project       = rafay_cloud_credential.eks-credentials.id
  }
  description   = "Rafay Cloud Credentials info"
}
