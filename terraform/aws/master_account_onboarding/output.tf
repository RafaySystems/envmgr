output "uuid" {
  value = random_uuid.external_id.result
}

output "master_role_arn" {
  value = resource.aws_iam_role.master-cluster-role.arn
}
