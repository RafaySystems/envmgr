resource "rafay_cloud_credential" "aws_creds" {
  name         = var.aws_cloud_provider_name
  project      = var.aws_cloud_provider_project
  description  = "description"
  type         = "cluster-provisioning"
  providertype = "AWS"
  awscredtype  = "accesskey"
  accesskey    = var.aws_cloud_provider_access_key
  secretkey    = var.aws_cloud_provider_secret_key
}
