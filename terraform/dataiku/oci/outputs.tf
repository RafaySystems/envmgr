output "instance_public_ip" {
  value = oci_core_instance.ubuntu_vm.public_ip
  description = "The public IP address of the Ubuntu instance"
}


output "dummy" {
  value = "dummy"
  description = "The public IP address of the Ubuntu instance"
}
