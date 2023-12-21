resource "rafay_group" "group-dev" {
  name = var.group
}

resource "rafay_groupassociation" "groupassociation" {
  project   = var.project_name
  group     = resource.rafay_group.group-dev.name
  roles     = var.roles
  add_users = [var.user]
}
