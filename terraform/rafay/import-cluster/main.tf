resource "null_resource" "kubectl" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOT
      wget "https://storage.googleapis.com/kubernetes-release/release/v1.28.2/bin/linux/amd64/kubectl"
      chmod +x ./kubectl
    EOT
  }
}

resource "local_sensitive_file" "kubeconfig" {
  depends_on = [null_resource.kubectl]
  content    = var.kube_config
  filename   = "kubeconfig.yaml"
}

resource "rafay_import_cluster" "import_cluster" {
  depends_on            = [local_sensitive_file.kubeconfig]
  clustername           = var.cluster_name
  projectname           = var.projectname
  blueprint             = var.blueprint
  location              = var.location
  kubernetes_provider   = "OTHER"
  provision_environment = "ONPREM"
}

resource "local_sensitive_file" "bootstrap" {
  content  = rafay_import_cluster.import_cluster.bootstrap_data
  filename = "bootstrap.yaml"
}

resource "null_resource" "debug1" {
  depends_on = [null_resource.kubectl, local_sensitive_file.kubeconfig, rafay_import_cluster.import_cluster, local_sensitive_file.bootstrap]
  triggers = {
    run = rafay_import_cluster.import_cluster.id
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "./kubectl --kubeconfig kubeconfig.yaml apply -f bootstrap.yaml"
  }
}
