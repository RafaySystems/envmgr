resource "rafay_cloud_credentials_v3" "cloud_credentials_vsphere" {
  metadata {
    name    = var.cloud_credential_name
    project = var.project_name
  }
  spec {
    type = "ClusterProvisioning"
    provider = "vsphere"
    credentials {
        gateway_id  = var.gateway_name
        vsphere_server  =var.vsphere_server
        username = var.vsphere_user
        password = var.vsphere_password
    } 
    sharing {
      enabled = false
    }
  }
}