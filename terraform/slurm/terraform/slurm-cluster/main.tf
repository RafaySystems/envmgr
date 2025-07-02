resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

#resource "local_file" "slurm_cluster_values" {
#  content = templatefile("${path.module}/templates/values-slurm-cluster.tftpl", {
#    storageclass   = var.storageclass
#    ssh_pub_key   = var.ssh_pub_key
#  })
#  filename        = "/tmp/values-slurm-cluster.yaml"
#  file_permission = "0644"
#}

resource "kubernetes_namespace" "slurm_cluster_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "slinky_data" {
  depends_on = [kubernetes_namespace.slurm_cluster_namespace]
  metadata {
    name      = "slinky-shared-pvc"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "10Gi"
      }
    }

    storage_class_name = var.storageclass
  }
}

resource "helm_release" "slurm_cluster" {
 # depends_on = [kubernetes_persistent_volume_claim.slinky_data]
  name             = "slurm"
  namespace        = var.namespace
  #create_namespace = true

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

  set {
    name  = "login.enabled"
    value = "true"
  }

  set {
    name  = "login.rootSshAuthorizedKeys[0]"
    value = var.ssh_pub_key
  }

    set {
    name  = "login.extraVolumes[0].name"
    value = "slinky-shared"
  }

  set {
    name  = "login.extraVolumes[0].persistentVolumeClaim.claimName"
    value = "slinky-shared-pvc"
  }

  set {
    name  = "login.extraVolumeMounts[0].name"
    value = "slinky-shared"
  }

  set {
    name  = "login.extraVolumeMounts[0].mountPath"
    value = "/shared"
  }

  set {
    name  = "compute.nodesets[0].name"
    value = "default"
  }

  set {
    name  = "compute.nodesets[0].enabled"
    value = "true"
  }

  set {
   name  = "compute.nodesets[0].replicas"
    value = var.compute_replicas
  }

  set {
    name  = "compute.nodesets[0].extraVolumes[0].name"
    value = "slinky-shared"
  }

  set {
    name  = "compute.nodesets[0].extraVolumes[0].persistentVolumeClaim.claimName"
    value = "slinky-shared-pvc"
  }

  set {
    name  = "compute.nodesets[0].extraVolumeMounts[0].name"
    value = "slinky-shared"
  }

  set {
    name  = "compute.nodesets[0].extraVolumeMounts[0].mountPath"
    value = "/shared"
  }

  set {
    name  = "compute.nodesets[0].partition.enabled"
    value = "true"
  }

  timeout = 300
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
  depends_on = [helm_release.slurm_cluster]

  provisioner "local-exec" {
    command = <<EOT
set -e  # Exit immediately on error

mkdir -p /tmp/kubectl-bin
wget -qO /tmp/kubectl-bin/kubectl "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x /tmp/kubectl-bin/kubectl

SLURM_LOGIN_IP="$(/tmp/kubectl-bin/kubectl --kubeconfig /tmp/kubeconfig get services -n ${var.namespace} -l app.kubernetes.io/instance=slurm,app.kubernetes.io/name=login -o jsonpath='{.items[0].status.loadBalancer.ingress[0].hostname}')"

echo "Slurm Login IP is: $SLURM_LOGIN_IP"

echo "$SLURM_LOGIN_IP" > slurm_login_ip.txt
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

data "local_file" "slurm_login_ip" {
    filename = "${path.module}/slurm_login_ip.txt"
  depends_on = [null_resource.get_slurm_login_ip]
}

output "slurm_access" {
  value = "ssh -p 2222 root@${data.local_file.slurm_login_ip.content} -i <path to private key>"
}

#output "slurm_url" {
#  value = "https://console.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
#}

#output "slurm_url_a" {
#  value = "https://acme.paas.rafay.dev/#/console/${var.projectid}/${var.cluster_name}?&namespace=${var.namespace}&command=${base64encode("exec -it -n ${var.namespace} slurm-controller-0 -c slurmctld -- /bin/sh")}&kubectl_type=namespace&edge_id=${data.local_file.edgeid.content}"
#}
