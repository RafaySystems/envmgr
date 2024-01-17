resource "null_resource" "run_script" {
   triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "chmod +x create-gateway.sh && ./create-gateway.sh"
    environment = {
      GATEWAY_NAME = var.gateway_name
      PROJECT_NAME = var.project_name
    }
  }
}

data "local_file" "output" {
  depends_on = [null_resource.run_script]
  filename = "output.json"
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "default" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


data "vsphere_ovf_vm_template" "ovfRemote" {
  name              = var.gateway_vm_name
  disk_provisioning = "thin"
  resource_pool_id  = data.vsphere_resource_pool.default.id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.host.id
  remote_ovf_url    = "https://dev-rafay-vmware-ova.s3.us-west-1.amazonaws.com/ovagatewat/out.ova"
  ovf_network_map = {
     "${var.vsphere_network}" = data.vsphere_network.network.id
  }
}

## Deployment of VM from Remote OVF
resource "vsphere_virtual_machine" "vmFromRemoteOvf" {
  name                 = var.gateway_vm_name
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host.id
  resource_pool_id     = data.vsphere_resource_pool.default.id
 dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovfRemote.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout = 0

 ovf_deploy {
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovfRemote.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovfRemote.disk_provisioning
    ovf_network_map           = data.vsphere_ovf_vm_template.ovfRemote.ovf_network_map
}
  
depends_on = [null_resource.run_script]
  vapp {
    properties = {
      "Bootstrap_Repo_URL"       = jsondecode(data.local_file.output.content).Bootstrap_url,
      "token"          = jsondecode(data.local_file.output.content).Token,
      "agent_id"     = jsondecode(data.local_file.output.content).agent_id, 
      "controller_endpoint"          =  var.rafay_controller_endpoint
    }
  }
}

## Checking Health of gateway 
resource "null_resource" "health_script" {
   triggers = {
    always_run = timestamp()
  }
  depends_on = [null_resource.run_script,vsphere_virtual_machine.vmFromRemoteOvf]
  provisioner "local-exec" {
    command = "chmod +x monitor_gateway_health.sh && ./monitor_gateway_health.sh"
    environment = {
      GATEWAY_NAME = var.gateway_name
      PROJECT_NAME = var.project_name
    }
  }
}

resource "null_resource" "delete_vsphere_gatway" {
  triggers = {
    gwname    = var.gateway_name
    projectname = var.project_name
    
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x delete-gateway.sh && ./delete-gateway.sh"
     environment = {
      GATEWAY_NAME = "${self.triggers.gwname}"
      PROJECT_NAME = "${self.triggers.projectname}"
    }
    }
  }
