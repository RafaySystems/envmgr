output "namepsace" {
  value = rafay_namespace.namespace.id
}

output "workload" {
  value = rafay_workload.workload.id
}

output "ingress_hostname" {
  value = var.hostname
}