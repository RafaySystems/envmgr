# resource "local_sensitive_file" "kubeconfig" {
#   content = var.kube_config
#   #content  = data.digitalocean_kubernetes_cluster.example.kube_config.0.raw_config
#   filename = "kubeconfig.yaml"
# }

resource "rafay_import_cluster" "import_cluster" {
  clustername           = var.cluster_name
  projectname           = var.projectname
  blueprint             = var.blueprint
  location              = var.location
  kubernetes_provider   = "OTHER"
  provision_environment = "ONPREM"
}

# resource "local_sensitive_file" "bootstrap" {
#   content  = rafay_import_cluster.import_cluster.bootstrap_data
#   filename = "bootstrap.yaml"
# }

# resource "null_resource" "debug1" {
#   depends_on = [local_sensitive_file.kubeconfig, rafay_import_cluster.import_cluster, local_sensitive_file.bootstrap]
#   triggers = {
#     run = rafay_import_cluster.import_cluster.id
#   }
#   # provisioner "local-exec" {
#   #   interpreter = ["/bin/bash", "-c"]
#   #   command     = <<EOT
#   #     exec -l $SHELL
#   #     export PATH=$PATH:$(pwd)
#   #     ./kubectl --kubeconfig kubeconfig.yaml apply -f bootstrap.yaml
#   #   EOT
#   # }
#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = "kubectl --kubeconfig kubeconfig.yaml apply -f bootstrap.yaml"
#   }
# }
