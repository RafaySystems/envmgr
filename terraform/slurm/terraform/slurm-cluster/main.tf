resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "local_file" "slurm_cluster_values" {
  content = templatefile("${path.module}/templates/values-slurm-cluster.tftpl", {
    storageclass   = var.storageclass
  })
  filename        = "/tmp/values-slurm-cluster.yaml"
  file_permission = "0644"
}

resource "helm_release" "slurm_cluster" {
  name             = "slurm"
  namespace        = var.namespace
  create_namespace = true

  repository       = "oci://ghcr.io/slinkyproject/charts"
  chart            = "slurm"
  version          = "0.3.0"

  set {
    name  = "mariadb.primary.persistence.storageClass"
    value = var.storageclass
  }

  set {
  name  = "controller.persistence.storageClass"
  value = var.storageclass
  }

  timeout = 300
  depends_on = [local_file.slurm_cluster_values]
}

#resource "null_resource" "get_edge_id" {
#  triggers = {
#    always_run = timestamp()
#  }
#  provisioner "local-exec" {
#    interpreter = ["/bin/bash", "-c"]
#    command     = "chmod +x ./rctl.sh; ./rctl.sh"
#    environment = {
#      cluster_name = var.cluster_name
#      rctlconfig = var.rctl_config_path
#    }
#  }
#}

#data "local_file" "edgeid" {
#    filename = "${path.module}/edgeid.txt"
#  depends_on = [null_resource.get_edge_id]
#}

resource "null_resource" "get_slurm_login_ip" {
  provisioner "local-exec" {
    command = <<EOT
SLURM_LOGIN_IP="$(kubectl --kubeconfig /tmp/kubeconfig get services -n slurm -l app.kubernetes.io/instance=slurm,app.kubernetes.io/name=login -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')"
echo "Slurm Login IP is: $SLURM_LOGIN_IP"
# Optional: write to a file for later use
echo "$SLURM_LOGIN_IP" > slurm_login_ip.txt
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

output "slurm_url" {
  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}

output "slurm_url_a" {
  value = "https://acme.paas.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}
