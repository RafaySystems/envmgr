resource "oci_core_instance" "ubuntu_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = var.instance_shape
  display_name        = "ubuntu-2204-instance-tim"

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_2204.images[0].id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "ubuntu_2204" {
  compartment_id = var.compartment_ocid
  operating_system = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape = var.instance_shape
  sort_by = "TIMECREATED"
  sort_order = "DESC"
}

output "instance_public_ip" {
  value = oci_core_instance.ubuntu_vm.public_ip
  description = "The public IP address of the Ubuntu instance"
}