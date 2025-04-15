resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "local_file" "slurm-cluster-values" {
  content = templatefile("${path.module}/templates/values-slurm-cluster.tftpl", {
    storageclass   = var.storageclass
  })
  filename        = "${path.module}/values-slurm-cluster.yaml"
  file_permission = "0644"
}

#resource "helm_release" "slurm-cluster" {
#  depends_on = [local_file.slurm-cluster-values]
#  create_namespace = true
#  name             = "slurm-cluster-${var.namespace}"
#  namespace        = var.namespace
#  repository       = "oci://ghcr.io/slinkyproject/charts/"
#  chart            = "slurm"
#  timeout          = 600
  #values           = [file("${path.module}/values-slurm-cluster.yaml")]
  #set {
  #  name  = "mariadb.primary.persistence.storageClass"
  #  value = var.storageclass
  #}

  #set {
  #  name  = "controller.persistence.storageClass"
  #  value = var.storageclass
  #}
  #set {
  #  name  = "compute.nodesets[0].persistentVolumeClaimRetentionPolicy.whenScaled"
  #  value = "Retain"
  #}
#}


# null_resource is used here rather hthen helm provider as chart fails to deploy successfully when the helm provdider is used
resource "null_resource" "slurm_cluster" {  
  provisioner "local-exec" {
    command = <<-EOT
      wget "https://get.helm.sh/helm-v3.17.0-linux-amd64.tar.gz" &&
	  tar -xvf helm-v3.17.0-linux-amd64.tar.gz &&
      cd linux-amd64/ &&
      chmod +x ./helm &&
      ./helm install slurm oci://ghcr.io/slinkyproject/charts/slurm  --namespace=${var.namespace}  --create-namespace  --set mariadb.primary.persistence.storageClass=${var.storageclass} --set controller.persistence.storageClass=${var.storageclass} --set compute.nodesets[0].persistentVolumeClaimRetentionPolicy.whenScaled=Retain --timeout 5m --kubeconfig=/tmp/kubeconfig
    EOT
  }
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
  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-cluster-${var.namespace}-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
}
