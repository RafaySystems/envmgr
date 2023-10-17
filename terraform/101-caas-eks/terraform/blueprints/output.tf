output "rafay_blueprint" {
  value = {
    project       = rafay_blueprint.blueprint.id
    spec          = rafay_blueprint.blueprint.spec
  }
  description   = "Rafay Blueprint info"
}
