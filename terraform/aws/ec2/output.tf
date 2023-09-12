output "ubuntu_public_dns" {
  value = aws_instance.ubuntu.public_dns
}
output "name" {
    value = aws_instance.ubuntu.tags["Name"]
}
output "ubuntu_public_dns" {
  value = aws_instance.ubuntu2.public_dns
}
output "name" {
    value = aws_instance.ubuntu2.tags["Name"]
}
