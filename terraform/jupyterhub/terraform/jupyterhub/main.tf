resource "random_id" "rnd" {
  keepers = {
    first = var.cluster_name
  }
  byte_length = 4
}

locals {
  # Create a unique namspace name
  namespace = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
}


resource "rafay_namespace" "namespace" {
  metadata {
    name    = local.namespace
    project = var.project
  }
  spec {
    drift {
      enabled = true
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  depends_on = [null_resource.rctl_install]
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

templatefile("values.yaml", {
  depends_on = [rafay_namespace.namespace]
  arn = aws_iam_role.aggregator[each.value].arn
  password = ${var.jupyter_admin_password}
  tolerations = ${yamlencode(var.hub_tolerations)}
  extraTolerations = ${yamlencode(var.singleuser_tolerations)}
  extraEnv = ${yamlencode(var.extra_env)}
})

resource "rafay_workload" "workload" {
  depends_on = [templatefile]
  metadata {
    name    = "${var.workload_name}-${local.namespace}"
    project = var.project
  }
  spec {
    namespace = local.namespace
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v-${random_id.rnd.hex}"
    artifact {
      type = "Helm"
      artifact {
        chart_path {
          name = "file://jupyterhub-3.2.1.tgz"
        }
        values_paths {
          name = "file://values.yaml"
        }
      }
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [rafay_workload.workload]
  create_duration = "30s"
}

resource "null_resource" "get-jupyterhub-ip" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc gen-ai-app-example1-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/jupyterhub.txt"
  }
  depends_on = [time_sleep.wait_30_seconds]
}

data "local_file" "jupyterhub-ip" {
    filename = "/tmp/jupyterhub.txt"
  depends_on = [null_resource.get-jupyterhub-ip]
}



#resource "null_resource" "genai_install" {
#  triggers = {
#    always_run = timestamp()
#  }
#  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
#  provisioner "local-exec" {
#    interpreter = ["/bin/bash", "-c"]
#    command     = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ls /tmp && ./kubectl apply -f ./genai-app.yaml -n ${local.namespace} --kubeconfig=/tmp/kubeconfig && ./kubectl expose deployment gen-ai --type=LoadBalancer --name=gen-ai-app-example1-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig "
#  }
#}

#resource "time_sleep" "wait_30_seconds_example1" {
#  depends_on      = [null_resource.genai_install]
#  create_duration = "60s"
#}