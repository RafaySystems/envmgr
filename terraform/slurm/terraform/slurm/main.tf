resource "helm_release" "slurm-operator" {
  count            = var.install_slurm_operator ? 1 : 0
  create_namespace = true
  name             = "slurm-operator"
  namespace        = "slurm-operator"
  repository       = "oci://ghcr.io/slinkyproject/charts/"
  chart            = "slurm-operator"
  version          = "0.1.0"
  values           = [file("${path.module}/values-operator.yaml")]
}


resource "helm_release" "slurm-cluster" {
  depends_on       = [helm_release.slurm-operator]
  count            = var.install_slurm_cluster ? 1 : 0
  create_namespace = true
  name             = "slurm-cluster-${var.namespace}"
  namespace        = var.namespace
  repository       = "oci://ghcr.io/slinkyproject/charts/"
  chart            = "slurm"
  version          = "0.1.0"
  values           = [file("${path.module}/values-slurm.yaml")]
}


resource "null_resource" "get_edge_id" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./rctl.sh; ./rctl.sh"
    environment = {
      cluster_name = var.cluster_name
      rctlconfig = var.rctl_config_path
    }
  }
}

data "local_file" "edgeid" {
    filename = "${path.module}/edgeid.txt"
  depends_on = ["null_resource.get_edge_id"]
}

output "slurm_url" {
  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-cluster-${var.namespace}-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}