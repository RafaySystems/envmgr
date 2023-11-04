output "public_ip" {
  value = "http://${data.local_file.kubeflow-ip.content}:3000"
}
