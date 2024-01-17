resource "random_id" "rnd" {
  keepers = {
    first = "${timestamp()}"
  }
  byte_length = 4
}

resource "local_file" "rafay_vmware_cluter_spec" {
  depends_on = [random_id.rnd]
  content = templatefile("${path.module}/templates/rafay-vmware.tftpl" ,{
    cluster_name   = var.cluster_name
    project_name   = var.project_name
    control_plane_ip  = var.control_plane_ip
    cloud_credentials = var.cloud_credentials
    k8s_version       = var.k8s_version
    vm_template       = var.vm_template
    vsphere_resource_pool      = var.vsphere_resource_pool
    vsphere_datacenter  = var.vsphere_datacenter
    vsphere_datastore   = var.vsphere_datastore
    vsphere_network        = var.vsphere_network
  })
  filename        = "${random_id.rnd.hex}-rafay-spec.yaml"
  file_permission = "0644"
}

resource "null_resource" "vmware_cluster" {
  triggers = {
    always_run = timestamp()
  }
  depends_on = [local_file.rafay_vmware_cluter_spec]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x cluster-provision.sh && ./cluster-provision.sh"
    environment = {
      filename = local_file.rafay_vmware_cluter_spec.filename
      PROJECT_NAME = var.project_name
    }
  }
}

resource "null_resource" "delete_vsphere_cluster" {
  triggers = {
    clustername    = var.cluster_name
    projectname    = var.project_name
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x cluster-delete.sh && ./cluster-delete.sh"
     environment = {
      CLUSTER_NAME = "${self.triggers.clustername}"
      PROJECT_NAME = "${self.triggers.projectname}"
    }
    }
  }
