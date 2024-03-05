/***************************
VPC Network Configuration
***************************/
resource "google_compute_network" "gke-vpc" {
  count                   = var.vpc_enabled && var.cloud_provider == "gcp" ? 1 : 0
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = "false"
  project                 = var.project_id
}

/***************************
Subnet Configuration
***************************/
resource "google_compute_subnetwork" "gke-subnet" {
  name          = "${var.cluster_name}-subnet"
  count         = var.vpc_enabled && var.cloud_provider == "gcp" ? 1 : 0
  region        = var.region
  network       = google_compute_network.gke-vpc[0].name
  ip_cidr_range = "10.150.0.0/24"
  project       = var.project_id
}


## Create Cloud Router

resource "google_compute_router" "router" {
  count         = var.vpc_enabled && var.cloud_provider == "gcp" ? 1 : 0
  project = var.project_id
  name    = "${var.cluster_name}-router"
  network = google_compute_network.gke-vpc[0].name
  region  = var.region
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  count         = var.vpc_enabled && var.cloud_provider == "gcp" ? 1 : 0
  name                               = "${var.cluster_name}-nat-router"
  project = var.project_id
  router                             = google_compute_router.router[0].name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/***************************
GKE Configuration
***************************/

# Add data block to provide latest k8s version as an output
data "google_container_engine_versions" "latest" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  provider = google-beta
  location = var.region
  project  = var.project_id
}

resource "google_container_cluster" "gke" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  name     = var.cluster_name
  project  = var.project_id
  location = length(var.node_zones) == 1 ? one(var.node_zones) : var.region
  release_channel {
    channel = var.release_channel
  }
  min_master_version = var.min_master_version
  # Default Node Pool is required, to create a cluster, but we need a custom one instead
  # So we delete the default
  remove_default_node_pool = true
  initial_node_count       = 1
  /*private_cluster_config {
    enable_private_nodes    = true
  }*/
  deletion_protection      = false

  network    = var.vpc_enabled ? google_compute_network.gke-vpc[0].name : var.network
  subnetwork = var.vpc_enabled ? google_compute_subnetwork.gke-subnet[0].name : var.subnetwork

  // Workload Identity Configuration
  workload_identity_config {
    workload_pool = "${data.google_project.cluster.project_id}.svc.id.goog"
  }
}
/***************************
GKE CPU Node Pool Config
***************************/
resource "google_container_node_pool" "cpu_nodes" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  name           = "tf-${var.cluster_name}-cpu-pool"
  project        = var.project_id
  location       = length(var.node_zones) == 1 ? one(var.node_zones) : var.region
  node_locations = length(var.node_zones) > 1 ? var.node_zones : null
  cluster        = google_container_cluster.gke[0].name
  node_count     = var.node_pool_config[var.node_pool_size]["cpu_node_count"]
  autoscaling {
    min_node_count = var.node_pool_config[var.node_pool_size]["cpu_node_pool_min_count"]
    max_node_count = var.node_pool_config[var.node_pool_size]["cpu_node_pool_max_count"]
  }
  node_config {
    image_type = "UBUNTU_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/compute"
    ]

    preemptible  = var.node_pool_config[var.node_pool_size]["use_cpu_spot_instances"]
    machine_type = var.node_pool_config[var.node_pool_size]["cpu_machine_type"]
    disk_size_gb = var.node_pool_config[var.node_pool_size]["cpu_node_pool_disk_size"]
    tags         = concat(["tf-managed", "${var.cluster_name}"], var.gpu_instance_tags)
    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      part_of    = var.cluster_name
      env        = var.project_id
      managed_by = "terraform"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  timeouts {
    create = "30m"
    update = "20m"
  }
}

/***************************
GKE GPU Node Pool Config
***************************/
resource "google_container_node_pool" "gpu_nodes" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  name           = "tf-${var.cluster_name}-gpu-pool"
  project        = var.project_id
  location       = length(var.node_zones) == 1 ? one(var.node_zones) : var.region
  node_locations = length(var.node_zones) > 1 ? var.node_zones : null
  cluster        = google_container_cluster.gke[0].name
  node_count     = var.node_pool_config[var.node_pool_size]["gpu_node_count"]
  autoscaling {
    min_node_count = var.node_pool_config[var.node_pool_size]["gpu_node_pool_min_count"]
    max_node_count = var.node_pool_config[var.node_pool_size]["gpu_node_pool_max_count"]
  }
  node_config {
    image_type = "UBUNTU_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/compute"
    ]
    guest_accelerator {
      type  = var.node_pool_config[var.node_pool_size]["gpu_type"]
      count = var.node_pool_config[var.node_pool_size]["gpu_count"]
    }

    preemptible  = var.node_pool_config[var.node_pool_size]["use_gpu_spot_instances"]
    machine_type = var.node_pool_config[var.node_pool_size]["gpu_machine_type"]
    disk_size_gb = var.node_pool_config[var.node_pool_size]["gpu_node_pool_disk_size"]
    tags         = concat(["tf-managed", "${var.cluster_name}"], var.gpu_instance_tags)
    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      part_of    = var.cluster_name
      env        = var.project_id
      managed_by = "terraform"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  timeouts {
    create = "30m"
    update = "20m"
  }
}

data "template_file" "kubeconfig" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  template = file("templates/kubeconfig.tpl")

  vars = {
    cluster_name           = var.cluster_name
    cluster_endpoint       = "https://${google_container_cluster.gke[0].endpoint}"
    cluster_ca_certificate = google_container_cluster.gke[0].master_auth.0.cluster_ca_certificate
    access_token           = data.google_client_config.provider.access_token
  }
}

resource "local_file" "kubeconfig" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  content  = data.template_file.kubeconfig[0].rendered
  filename = "kubeconfig"
}



resource "rafay_import_cluster" "gke" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  clustername           = var.cluster_name
  projectname           = var.project_name
  blueprint             = var.gke_blueprint
  blueprint_version     = var.gke_blueprint_version
  kubernetes_provider   = "GKE"
  provision_environment = "CLOUD"
  values_path           = "values.yaml"
  depends_on 	= [google_container_node_pool.gpu_nodes]
  lifecycle {
    ignore_changes = [
      bootstrap_path
    ]
  }
}

resource "helm_release" "rafay_operator" {
  count = var.cloud_provider == "gcp"  ? 1 : 0
  name       = "v2-infra"
  namespace = "rafay-system"
  create_namespace = true
  repository = "https://rafaysystems.github.io/rafay-helm-charts/"
  chart      = "v2-infra"

  values = [rafay_import_cluster.gke[0].values_data]
  lifecycle {
    ignore_changes = [
      version
    ]
  }
  depends_on = [local_file.kubeconfig]
}