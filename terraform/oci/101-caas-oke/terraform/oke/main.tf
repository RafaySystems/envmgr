
module "vcn" {
  source         = "oracle-terraform-modules/vcn/oci"
  version        = "3.1.0"
  compartment_id = var.compartment_id
  region         = var.region

  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null

  vcn_name  = var.vcn_name
  vcn_cidrs = [var.vcn_cidr]

  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true
}

resource "oci_core_security_list" "private-security-list" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "security-list-for-private-subnet"
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
    }
  }
}

resource "oci_core_security_list" "public-security-list" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "security-list-for-public-subnet"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }
  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
    }
  }
}

resource "oci_core_subnet" "vcn-private-subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = cidrsubnet(var.vcn_cidr, 8, 1)
  route_table_id    = module.vcn.nat_route_id
  security_list_ids = [oci_core_security_list.private-security-list.id]
  display_name      = "private-subnet"
}

resource "oci_core_subnet" "vcn-public-subnet" {
  compartment_id    = var.compartment_id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = cidrsubnet(var.vcn_cidr, 8, 10)
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public-security-list.id]
  display_name      = "public-subnet"
}

resource "oci_core_network_security_group" "oke_security_group" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "oke_api_endpoint_security_group"
}

resource "oci_core_network_security_group_security_rule" "api_security_group_security_rule" {
  network_security_group_id = oci_core_network_security_group.oke_security_group.id
  direction                 = "INGRESS"
  protocol                  = 6
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  tcp_options {
    destination_port_range {
      max = 6443
      min = 6443
    }
    source_port_range {
      max = 65535
      min = 1
    }
  }
}

resource "oci_containerengine_cluster" "oke-cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = var.cluster_name
  vcn_id             = module.vcn.vcn_id
  endpoint_config {
    is_public_ip_enabled = true
    nsg_ids              = [oci_core_network_security_group.oke_security_group.id]
    subnet_id            = oci_core_subnet.vcn-public-subnet.id
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
    service_lb_subnet_ids = [oci_core_subnet.vcn-public-subnet.id]
  }
}

resource "oci_containerengine_node_pool" "oke-node-pool" {
  cluster_id         = oci_containerengine_cluster.oke-cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.k8s_version
  name               = "demo-oke-pool"
  node_config_details {
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = oci_core_subnet.vcn-private-subnet.id
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
