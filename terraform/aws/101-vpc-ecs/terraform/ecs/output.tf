output "public_ip" {
  value = data.aws_network_interface.ip.association[0].public_ip
}
