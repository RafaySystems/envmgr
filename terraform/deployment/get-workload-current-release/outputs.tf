output "rollback_release_branch" {
  value = data.external.get_rollback_release.result.rollback_branch
}
