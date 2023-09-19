# Create a VPC network in the project.
resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = "em-vpc-${var.prefix}"
  auto_create_subnetworks = false # You can create subnets separately if needed
}

# Create a subnet within the VPC.
resource "google_compute_subnetwork" "subnet" {
  project = var.project_id
  name    = "em-subnet-${var.prefix}"
  #region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = var.ip_cidr_range
}

# Create a router.
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "em-router-${var.prefix}"
  network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = "em-nat-${var.prefix}"
  router                             = google_compute_router.router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


# Create a firewall rules.
resource "google_compute_firewall" "firewall-e" {
  project            = var.project_id
  name               = "em-egress-${var.prefix}"
  network            = google_compute_network.vpc.self_link
  priority           = 1000
  direction          = "EGRESS"
  source_ranges      = [var.ip_cidr_range]
  destination_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "all"
  }
}
