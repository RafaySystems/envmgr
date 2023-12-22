resource "oci_containerengine_cluster" "oke-cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  endpoint_config {
    is_public_ip_enabled = true
    nsg_ids              = [var.nsg_ids]
    subnet_id            = var.subnet_id
  }
  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
    service_lb_subnet_ids = [var.subnet_id]
  }
}

resource "oci_containerengine_node_pool" "oke-node-pool" {
  cluster_id         = oci_containerengine_cluster.oke-cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "oke-pool"
  node_config_details {
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.private_subnet_id
    }
    size = var.size
  }
  node_shape = "VM.Standard.E3.Flex"
  node_shape_config {
    memory_in_gbs = 8.0
    ocpus         = 4
  }
  node_source_details {
    image_id    = var.image
    source_type = "image"
  }
}

data "oci_containerengine_cluster_kube_config" "test_cluster_kube_config" {
  cluster_id = oci_containerengine_cluster.oke-cluster.id
}
