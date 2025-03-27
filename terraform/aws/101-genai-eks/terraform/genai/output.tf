

output "namepsace" {
  value =local.namespace
}

#output "public_ip_example1" {
#  value = "http://${data.local_file.gen-ai-ip-example1.content}:80"
#}

output "public_ip_example2" {
  value = "http://${data.local_file.gen-ai-ip-example2.content}:8000"
}
