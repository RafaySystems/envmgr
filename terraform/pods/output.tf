output "username" {
  value = "ubuntu"
}

output "password" {
  value = "password"
}

output "ssh_port" {
  value = random_integer.port.result
}

output "ip" {
  value = var.remote_host
}