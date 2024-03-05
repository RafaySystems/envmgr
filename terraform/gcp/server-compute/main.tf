resource "google_compute_firewall" "webserverrule" {
  count = var.cloud_provider == "gcp" ? 1 : 0
  name    = "gritfy-webserver"
  project = var.project
  network = "default"
  allow {
    protocol = "tcp"
    ports    = var.security_group_ports
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["webserver"]
}
# We create a public IP address for our google compute instance to utilize
resource "google_compute_address" "static" {
  count = var.cloud_provider == "gcp" ? var.num_instances : 0
  name = "vm-public-address"
  project = var.project
  region = var.region
  depends_on = [ google_compute_firewall.webserverrule[0] ]
}
resource "google_compute_instance" "dev" {
  count = var.cloud_provider == "gcp" ? var.num_instances : 0
  name         = "${var.name}-${count.index}"
  project = var.project
  machine_type = var.gcp_instance_config[var.instance_size]["machine_type"]
  zone         = "${var.region}-a"
  tags         = ["externalssh","webserver"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = var.gcp_instance_config[var.instance_size]["node_disk_size"]
    }
  }
  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static[count.index].address
    }
  }
  metadata = {
    ssh-keys               = "${var.ssh_user}:${var.ssh_public_key}"
  }
  depends_on = [ google_compute_firewall.webserverrule[0] ]
}