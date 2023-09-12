resource "rafay_download_kubeconfig" "kubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
  depends_on = [rafay_aks_cluster.aks-cluster]
}


resource null_resource setup-argo {
 triggers = {
    cluster_name     = var.cluster_name
    app_name           = var.app_name
    argocd_server      = var.argo_server
    argocd_username    = var.argo_username
    argocd_password    = var.argo_password
  }

  depends_on = [rafay_download_kubeconfig.kubeconfig]


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

  provisioner "local-exec" {
    when    = destroy
    interpreter = ["/bin/bash","-c"]
    command = "./scripts/delete_argo.sh ${self.triggers.cluster_name} ${self.triggers.app_name} ${self.triggers.argocd_server} ${self.triggers.argocd_username} ${self.triggers.argocd_password}"
  }
}