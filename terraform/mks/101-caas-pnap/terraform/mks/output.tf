output "cluster_name" {
  value = "${local.uniquename}-cluster"
}

output "public_ip" {
  value = var.public_ip
}
