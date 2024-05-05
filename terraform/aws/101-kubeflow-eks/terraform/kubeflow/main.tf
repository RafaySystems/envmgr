

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.eks_cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "null_resource" "kubectl_install" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ls /tmp && pwd && ls && ./kubectl"
  }
}

resource "null_resource" "cahnge" {
  triggers = {
    always_run = timestamp()
  }
  #depends_on = [null_resource.kubeflow_install]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./kubectl && ls /tmp && pwd && ls && ./kubectl"
  }
}




resource "null_resource" "lb_install" {
  triggers = {
    always_run = timestamp()
  }
  #depends_on = [null_resource.kubeflow_install]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "./kubectl expose deployment istio-ingressgateway --type=LoadBalancer --name=kubeflow-ui-loadbalancer -n istio-system --kubeconfig=/tmp/kubeconfig "
  }
}


resource "time_sleep" "wait_60_seconds" {
  #depends_on      = [null_resource.kubeflow_install]
  depends_on      = [null_resource.lb_install]
  create_duration = "60s"
}

resource "null_resource" "get_kubeflow_ip" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "./kubectl get svc kubeflow-ui-loadbalancer -n istio-system --kubeconfig=/tmp/kubeconfig | awk -F' ' '{print $4}' | tail -1 | tr -d '\n' >> /tmp/kubeflow_ip.txt"
  }
  depends_on = [time_sleep.wait_60_seconds]
}

data "local_file" "kubeflow-ip" {
    filename = "/tmp/kubeflow_ip.txt"
  depends_on = [null_resource.get_kubeflow_ip]
}
