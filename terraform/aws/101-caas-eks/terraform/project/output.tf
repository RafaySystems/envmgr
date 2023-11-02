output "rafay_project" {
  value = {
    project       = rafay_project.project.id
    spec          = rafay_project.project.spec
  }
  description   = "Rafay project info"
}
