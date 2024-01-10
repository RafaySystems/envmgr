output "repository" {
  value = resource.rafay_repositories.opa_repository.metadata[0].name
}
