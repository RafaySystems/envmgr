resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

resource "local_file" "rafay_mks_cluter_spec" {
  depends_on = [random_id.rnd]
  content = templatefile("${path.module}/templates/rafay-mks.tftpl", {
    cluster_name   = var.cluster_name
    private_ip     = var.private_ip
    public_ip      = var.public_ip
    hostname       = var.hostname
    server_count   = var.server_count
    project_name   = var.project_name
    k8s_version    = var.k8s_version
    rafay_location = "${lookup(var.location_mapping, var.rafay_location)}"
  })
  filename        = "${var.cluster_name}-${random_id.rnd.hex}-rafay-spec.yaml"
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
    name    = var.cluster_name
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
  name        = "${var.cluster_name}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.project_name}"
  group = "${var.cluster_name}-group"
  namespaces = ["${local.namespace}"]
  roles = ["CLUSTER_ADMIN"]
  add_users = ["${var.username}"]
}