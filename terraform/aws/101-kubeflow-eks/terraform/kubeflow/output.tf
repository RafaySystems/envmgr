output "public_ip" {
  value = "http://${data.local_file.kubeflow-ip.content}:8080"
}

output "default-username" {
  value = "user@example.com"
}
output "default-password" {
  value = "12341234"
}
