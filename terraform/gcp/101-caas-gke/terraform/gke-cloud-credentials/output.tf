output "credentials" {
  value = rafay_cloud_credentials_v3.gke-credentials.metadata[0].name

}
