#Data source for image
data "google_compute_image" "image" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

#Create a GCP compute instance.
resource "google_compute_instance" "instance" {
  project      = var.project_id
  name         = "em-instance-${var.prefix}"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = data.google_compute_image.image.self_link
    }
  }
  network_interface {
    subnetwork = var.subnetwork
  }
}
