output "sanity_workload_name" {
  value = var.sanity_workload_name
}

output "deployment_phase" {
  value = var.sanity_phase
}

output "rollback_action" {
  value = var.rollback != "false" ? "workload was rolled back to revision ${var.workload_rollback_release_branch}" : "no_rollback"
}

output "workload_release_branch" {
  value = var.rollback != "false" ? "${var.workload_rollback_release_branch}" : "${var.revision}"
}
