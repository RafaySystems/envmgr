resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "local_file" "slurm-cluster-values" {
  content = templatefile("${path.module}/templates/values-slurm-cluster.tftpl", {
    storageclass   = var.storageclass
  })
  filename        = "/${path.module}/values-slurm-cluster.yaml"
  file_permission = "0644"
}

resource "helm_release" "slurm_cluster" {
  name             = "slurm"
  namespace        = var.namespace
  create_namespace = true

  repository       = "oci://ghcr.io/slinkyproject/charts"
  chart            = "slurm"
  version          = "0.3.0"

  values = [
    file("${path.module}/values-slurm-cluster.yaml")
  ]

  timeout = 300  
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
  depends_on = [null_resource.get_edge_id]
}

output "slurm_url" {
  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}

output "slurm_url_a" {
  value = "https://acme.paas.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}
