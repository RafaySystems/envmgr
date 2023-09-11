resource null_resource setup-argo {
 triggers = {
    cluster_name     = var.cluster_name
  }

  depends_on = [rafay_download_kubeconfig.tfkubeconfig]


  provisioner "local-exec" {
    interpreter = ["/bin/bash","-c"]
    command = "./scripts/setup-argo.sh"
    environment = {
      CLUSTER_NAME      = var.cluster_name
      APP_NAMESPACE      = var.app_namespace
      APP_NAME           = var.app_name
      ARGOCD_SERVER      = var.argo_server
      ARGOCD_USERNAME    = var.argo_username
      ARGOCD_PASSWORD    = var.argo_password
    }
  }
}