output "public_ip" {
  value = "http://${data.aws_network_interface.ip.association[0].public_ip}:${var.container_port}"
}
