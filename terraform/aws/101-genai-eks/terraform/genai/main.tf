locals {
  namespace = var.namespace
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}


resource "rafay_workload" "install_example" {
  metadata {
    name    = "genai2-${local.namespace}"
    project = var.project
  }
  spec {
    namespace = local.namespace
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v1"
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://genai-app-example.yaml"
        }
      }
    }
  }
}

resource "time_sleep" "wait_for_lb" {
  depends_on      = [rafay_workload.install_example]
  create_duration = "30s"
}


resource "null_resource" "download_kubectl" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl "
  }
}

resource "null_resource" "get-gen-ai-ip-example" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc gen-ai-app-example-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/gen-ai-ip-example.txt"
  }
  depends_on = [
      time_sleep.wait_for_lb,
      null_resource.download_kubectl
]
}

data "local_file" "gen-ai-ip-example" {
    filename = "/tmp/gen-ai-ip-example.txt"
  depends_on = [null_resource.get-gen-ai-ip-example]
}

