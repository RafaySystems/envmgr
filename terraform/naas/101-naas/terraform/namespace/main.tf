# Create a unique random number to be used in the creation of a unique namespace name
resource "random_id" "rnd" {
  keepers = {
    first = var.cluster_name
  }
  byte_length = 4
}

# Create a unique namspace name using the username of the user who triggered the environment creation
locals {
  namespace1 = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
  namespace2 = replace(local.namespace1,"+","-")
  namespace3 = replace(local.namespace2,".","-")
  namespace4 = replace(local.namespace3,"+","-")
  namespace = lower(local.namespace4)
}

# Create the namespace with a resource quota
# Additional details can be found at https://registry.terraform.io/providers/RafaySystems/rafay/latest/docs/resources/namespace
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

# Downlod the cluster kubeconfig file which will be used to execute kubectl commands on the cluster
# Additional details can be found at https://registry.terraform.io/providers/RafaySystems/rafay/latest/docs/resources/download_kubeconfig
resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.cluster_name
  output_folder_path = "/tmp"
  filename           = "kubeconfig-${timestamp()}"
}

# Create a Network Policy spec file from the networkpolicy.yaml file in the TF path and update the namespace name in the spec with the previously created unique namespace name
resource "local_file" "create_network_policy" {
  content  = templatefile("networkpolicy.yaml", {namespace = local.namespace })
  filename = "/tmp/networkpolicy.yaml"
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
}

# Execute commands to download kubectl binary
resource "null_resource" "install_network_policy" {
  triggers  =  { always_run = "${timestamp()}" }
  provisioner "local-exec" {
    command = "wget \"https://dl.k8s.io/release/$(wget --output-document - --quiet https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl\" && chmod +x ./kubectl && ./kubectl apply -f /tmp/networkpolicy.yaml -n ${local.namespace} --kubeconfig=/tmp/${rafay_download_kubeconfig.tfkubeconfig.filename}"
  }
  depends_on = [local_file.create_network_policy]
}

# Create  user group in Rafay
# Additional details can be found at https://registry.terraform.io/providers/RafaySystems/rafay/latest/docs/resources/group
resource "rafay_group" "group" {
  name        = "${local.namespace}-group"
}

# Associate the user that initiated the environment creation with the the previously created user group.  Assign the group namespace admin privledges
# Additional details can be found at https://registry.terraform.io/providers/RafaySystems/rafay/latest/docs/resources/groupassociation
resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.project}"
  group = "${local.namespace}-group"
  namespaces = ["${local.namespace}"]
  roles = ["NAMESPACE_ADMIN"]
  add_users = ["${var.username}"]
  idp_user = var.user_type
}


# If a collaborator user was provided, associate the collaborator user with the user group
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
