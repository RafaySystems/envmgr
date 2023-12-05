output "pnap_server_hostname" {
  value = pnap_server.rafay_server[*].hostname
}

output "pnap_server_location" {
  value = pnap_server.rafay_server[*].location
}

output "pnap_server_private_ip" {
  value = flatten(pnap_server.rafay_server[*].private_ip_addresses)
}

output "pnap_server_pubic_ip" {
  value = flatten(pnap_server.rafay_server[*].public_ip_addresses)
}

output "total_instances" {
  value = var.total_instances
}
