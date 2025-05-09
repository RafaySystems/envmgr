resource "random_integer" "example" {
  min = 1
  max = 100
}

locals {
  username = split("@", var.em_username)[0]
  randomnumber   =  random_integer.example.result
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network_controlplane" {
  name          = var.vsphere_network_controlplane
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_virtual_machine" "vm_template" {
  name          = var.vsphere_vm_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name  = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


# Declare the storage policy only if it is not an empty string
locals {
  storage_policy_enabled = var.vsphere_storage_policy != ""
}

# Conditionally create the storage policy data block
data "vsphere_storage_policy" "policy" {
  count = local.storage_policy_enabled ? 1 : 0
  name  = var.vsphere_storage_policy
}

resource "vsphere_virtual_machine" "controlplane" {
  # https://github.com/hashicorp/terraform-provider-vsphere/issues/1902
  # ignoring these fields due to the above issue and its causing the vm to restart
  lifecycle {
    ignore_changes = [
      ept_rvi_mode,
      hv_mode
    ]
  }
  name                 = "${var.controlplane_vm_prefix}-${var.username}-${var.randomnumber}"
  guest_id             = data.vsphere_virtual_machine.vm_template.guest_id
  firmware             = data.vsphere_virtual_machine.vm_template.firmware
  num_cpus             = var.controlplane_vm_cpu
  num_cores_per_socket = var.controlplane_vm_cpu
  memory               = var.controlplane_vm_memory * 1024
  nested_hv_enabled    = true
  vvtd_enabled         = true
  enable_disk_uuid     = true
  #Using compute_cluster resource pool in the absence of permission.
  resource_pool_id     = data.vsphere_compute_cluster.compute_cluster.resource_pool_id
  #Use data.vsphere_resource_pool.pool.id for resource_pool_id (example below line) line instead above line in case you have resource pool and permission configured else you will get Error: error cloning virtual machine: ServerFaultCode: Permission to perform this operation was denied. Error
  #resource_pool_id    = data.vsphere_resource_pool.pool.id 
  datastore_id         = data.vsphere_datastore.datastore.id
  scsi_type            = data.vsphere_virtual_machine.vm_template.scsi_type
  storage_policy_id = local.storage_policy_enabled && length(data.vsphere_storage_policy.policy) > 0 ? data.vsphere_storage_policy.policy[0].id : null
  disk {
    unit_number      = 0
    label            = "os"
    size             = max(data.vsphere_virtual_machine.vm_template.disks.0.size, var.vm_disk_os_size_controlplane)
    eagerly_scrub    = data.vsphere_virtual_machine.vm_template.disks.0.eagerly_scrub
    thin_provisioned = true
  }
  disk {
    unit_number      = 1
    label            = "data"
    size             = var.vm_disk_data_size_controlplane
    eagerly_scrub    = data.vsphere_virtual_machine.vm_template.disks.0.eagerly_scrub
    thin_provisioned = true
  }
  network_interface {
    network_id  = data.vsphere_network.network_controlplane.id
    adapter_type = data.vsphere_virtual_machine.vm_template.network_interface_types.0
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.vm_template.id
  }
}
