locals {
  namespace = var.namespace
}

resource "null_resource" "rctl_install" {
  depends_on = [rafay_namespace.namespace]
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget \"https://s3.amazonaws.com/rafay-cli/publish/rctl-linux-amd64.tar.bz2\" && tar -xjf rctl-linux-amd64.tar.bz2 -C ./ &&  chmod +x ./rctl  &&./rctl create iam-service-account ${var.cluster_name} --name gen-ai --namespace ${local.namespace} --policy-document bedrock-policy.json -p ${var.project}"
  }
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  depends_on = [null_resource.rctl_install]
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "null_resource" "genai_install" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ls /tmp && ./kubectl apply -f ./genai-app.yaml -n ${local.namespace} --kubeconfig=/tmp/kubeconfig && ./kubectl expose deployment gen-ai --type=LoadBalancer --name=gen-ai-app-example1-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig "
  }
}


resource "rafay_workload" "workload" {
  depends_on = [rafay_namespace.namespace]
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
      type = "Yaml"
      artifact {
        paths {
          name = "file://genai-app-example2.yaml"
        }
      }
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [rafay_workload.workload]
  create_duration = "30s"
}

resource "null_resource" "get-gen-ai-ip-example1" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc gen-ai-app-example1-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/gen-ai-ip-example1.txt"
  }
  depends_on = [time_sleep.wait_30_seconds]
}

data "local_file" "gen-ai-ip-example1" {
    filename = "/tmp/gen-ai-ip-example1.txt"
  depends_on = [null_resource.get-gen-ai-ip-example1]
}

resource "null_resource" "get-gen-ai-ip-example2" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc gen-ai-app-example2-lb -n ${local.namespace} --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/gen-ai-ip-example2.txt"
  }
  depends_on = [time_sleep.wait_30_seconds]
}

data "local_file" "gen-ai-ip-example2" {
    filename = "/tmp/gen-ai-ip-example2.txt"
  depends_on = [null_resource.get-gen-ai-ip-example2]
}

