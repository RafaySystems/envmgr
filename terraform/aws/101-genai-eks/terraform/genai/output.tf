output "namepsace" {
  value =local.namespace
}

output "public_ip_example" {
  value = "http://${data.local_file.gen-ai-ip-example.content}:8000"
}

output "cluster_name" {
  value =var.cluster_name
}