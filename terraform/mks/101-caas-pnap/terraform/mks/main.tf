resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

locals {
  # Create a unique name
  uniquename = "${element(split("@",var.username),0)}-${random_id.rnd.dec}"
}

resource "local_file" "rafay_mks_cluter_spec" {
  depends_on = [random_id.rnd]
  content = templatefile("${path.module}/templates/rafay-mks.tftpl", {
    cluster_name   = "${local.uniquename}-cluster"
    private_ip     = var.private_ip
    public_ip      = var.public_ip
    hostname       = var.hostname
    server_count   = var.server_count
    project_name   = var.project_name
    k8s_version    = var.k8s_version
    rafay_location = "${lookup(var.location_mapping, var.rafay_location)}"
  })
  filename        = "${local.uniquename}-${random_id.rnd.hex}-rafay-spec.yaml"
  file_permission = "0644"
}

resource "null_resource" "mks_cluster" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [local_file.rafay_mks_cluter_spec]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./provision.sh; ./provision.sh"
    environment = {
      filename = local_file.rafay_mks_cluter_spec.filename
    }
  }
}

resource "null_resource" "delete_mks_cluster" {
  triggers = {
    name    = "${local.uniquename}-cluster"
    project = var.project_name
  }
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./delete.sh; ./delete.sh"
    environment = {
      CLUSTER = "${self.triggers.name}"
      PROJECT = "${self.triggers.project}"
    }
  }
}

resource "rafay_group" "group" {
  name        = "${local.uniquename}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.project_name}"
  group = "${local.uniquename}-group"
  roles = ["CLUSTER_ADMIN"]
  add_users = ["${var.username}"]
}
