output "ubuntu_public_dns" {
  value = aws_instance.ubuntu.public_dns
}
output "name" {
    value = aws_instance.ubuntu.tags["Name"]
}
