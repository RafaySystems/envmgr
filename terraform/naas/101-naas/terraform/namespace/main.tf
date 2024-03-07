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
    resource_quotas {
		config_maps = "10"
		cpu_requests = var.cpu
		memory_requests = var.memory
                cpu_limits = "4000m"
                memory_limits = "4096Mi"
		persistent_volume_claims = "2"
		pods = "30"
		replication_controllers = "5"
		services = "10"
		services_load_balancers = "10"
		services_node_ports = "10"
		storage_requests = "1Gi"
	}
}
  }


resource "rafay_group" "group" {
  name        = "${local.namespace}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.project}"
  group = "${local.namespace}-group"
  namespaces = ["${local.namespace}"]
  roles = ["NAMESPACE_ADMIN"]
  add_users = ["${var.username}"]
  idp_user = var.user_type
}


resource "rafay_groupassociation" "groupassociation_collaborators" {
  count = var.collaborator == "user_email" ? 0 : 1
  depends_on = [rafay_groupassociation.groupassociation]
  project = "${var.project}"
  roles = ["NAMESPACE_ADMIN"]
  group = "${local.namespace}-group"
  namespaces = ["${local.namespace}"]
  add_users = ["${var.collaborator}"]
  idp_user = true
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "null_resource" "create_network_policy" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "file" {
  source      = templatefile("networkpolicy.yaml", {namespace = local.namespace })
  destination = "/tmp/networkpolicy.yaml"
  }
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
}

resource "null_resource" "install_network_policy" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ./kubectl apply -f /tmp/networkpolicy.yaml -n ${local.namespace} --kubeconfig=/tmp/kubeconfig"
  }
  depends_on = [null_resource.create_network_policy]
}