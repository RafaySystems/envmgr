output "namespace" {
  value = rafay_namespace.namespace.id
}

output "url" {
  value = "http://${var.public_ip}" 
}