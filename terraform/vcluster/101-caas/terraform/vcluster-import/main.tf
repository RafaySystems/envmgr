/*resource "rafay_project" "vcluster_project" {
  metadata {
    name = var.project_name
  }
  spec {
    default = false
  }
}*/

locals {
  rafay_resource_version = "v1"
  user = element(split("@", var.username), 0)
  user_norm = replace("${local.user}", "+", "-")
}

resource "rafay_import_cluster" "vcluster" {
  clustername           = var.cluster_name
  #projectname           = rafay_project.vcluster_project.id
  projectname           = var.project_name
  blueprint             = var.blueprint
  blueprint_version     = var.blueprint_version
  kubernetes_provider   = "OTHER"
  provision_environment = "CLOUD"
  bootstrap_path        = "bootstrap.yaml"
  labels = {
    "dgx-user" = "${local.user_norm}"
  }
}

/*resource "rafay_group" "group-dev" {
  name = var.group
}

resource "rafay_groupassociation" "groupassociation" {
  #project   = rafay_project.vcluster_project.id
  project   = var.project_name
  group     = resource.rafay_group.group-dev.name
  roles     = ["PROJECT_ADMIN"]
  add_users = [var.username]
  idp_user = var.user_type
}


resource "rafay_groupassociation" "groupassociation_collaborators" {
  count = var.collaborator == "user_email" ? 0 : 1
  depends_on = [rafay_groupassociation.groupassociation]
  #project   = rafay_project.vcluster_project.id
  project   = var.project_name
  roles     = ["PROJECT_ADMIN"]
  group     = resource.rafay_group.group-dev.name
  add_users = ["${var.collaborator}"]
  idp_user = true
}*/

resource "local_file" "dedicated_rule" {
  content = templatefile("${path.module}/templates/dedicated.tftpl", {
    cluster = "${var.cluster_name}"
    user    = "${local.user_norm}"
  })
  filename        = "templates/dedicated.yaml"
  file_permission = "0644"
}

resource "local_file" "default_rule" {
  content = templatefile("${path.module}/templates/default.tftpl", {
    cluster = "${var.cluster_name}"
    user    = "${local.user_norm}"
  })
  filename        = "templates/default.yaml"
  file_permission = "0644"
}


resource "rafay_ztkarule" "default_rule" {
  depends_on = [local_file.default_rule]
  metadata {
    name = "${var.cluster_name}-${local.user_norm}-default-rule"
  }
  spec {
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://templates/default.yaml"
        }
      }
      options {
        force                       = true
        disable_open_api_validation = true
      }
    }
    cluster_selector {
      select_all = true
    }
    project_selector {
      select_all = true
    }
    version   = local.rafay_resource_version
    published = true
  }
}

resource "rafay_ztkarule" "dedicated_rule" {
  depends_on = [local_file.dedicated_rule]
  metadata {
    name = "${var.cluster_name}-${local.user_norm}-dedicated-rule"
  }
  spec {
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://templates/dedicated.yaml"
        }
      }
      options {
        force                       = true
        disable_open_api_validation = true
      }
    }
    cluster_selector {
      match_labels = {
        "dgx-user" = "${local.user_norm}"
      }
    }
    project_selector {
      select_all = true
    }
    version   = local.rafay_resource_version
    published = true
  }
}

resource "rafay_ztkapolicy" "ztkapolicy" {
  metadata {
    name = "${var.cluster_name}-${local.user_norm}-ztkapolicy"
  }
  spec {
    ztka_rule_list {
      name    = resource.rafay_ztkarule.default_rule.metadata[0].name
      version = local.rafay_resource_version
    }
    ztka_rule_list {
      name    = resource.rafay_ztkarule.dedicated_rule.metadata[0].name
      version = local.rafay_resource_version
    }
    version = local.rafay_resource_version
  }
}

resource "rafay_customrole" "rafay_customrole" {
  metadata {
    name = "${var.cluster_name}-${local.user_norm}-customrole"
  }
  spec {
    ztka_policy_list {
      name    = resource.rafay_ztkapolicy.ztkapolicy.metadata[0].name
      version = local.rafay_resource_version
    }
    base_role = "PROJECT_ADMIN"
  }
}

resource "rafay_group" "dgx-group" {
  name  = "${var.cluster_name}-${local.user_norm}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  group        = rafay_group.dgx-group.name
  add_users    = [var.username]
  project      = var.project_name
  custom_roles = [rafay_customrole.rafay_customrole.metadata[0].name]
}

resource "rafay_group" "collab-group" {
  name  = "${var.cluster_name}-${local.user_norm}-collab"
}

resource "rafay_groupassociation" "collab-groupassociation" {
  group        = rafay_group.collab-group.name
  add_users    = [var.username]
  project      = var.project_name
  roles     = ["ENVIRONMENT_TEMPLATE_USER"]
}
