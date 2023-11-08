

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.eks_cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "null_resource" "kubeflow_install" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ls /tmp && ./kubectl apply -k \"github.com/kubeflow/pipelines/manifests/kustomize/cluster-scoped-resources?ref=2.0.3\" --kubeconfig=/tmp/kubeconfig && ./kubectl wait --for condition=established --timeout=60s crd/applications.app.k8s.io --kubeconfig=/tmp/kubeconfig  && ./kubectl apply -k \"github.com/kubeflow/pipelines/manifests/kustomize/env/platform-agnostic-pns?ref=2.0.3\" --kubeconfig=/tmp/kubeconfig && ./kubectl expose deployment ml-pipeline-ui --type=LoadBalancer --name=kubeflow-ui-loadbalancer -n kubeflow --kubeconfig=/tmp/kubeconfig "
  }
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [null_resource.kubeflow_install]
  create_duration = "30s"
}

resource "null_resource" "get_kubeflow_ip" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc kubeflow-ui-loadbalancer -n kubeflow --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/kubeflow_ip.txt"
  }
  depends_on = [time_sleep.wait_30_seconds]
}

data "local_file" "kubeflow-ip" {
    filename = "/tmp/kubeflow_ip.txt"
  depends_on = [null_resource.get_kubeflow_ip]
}
