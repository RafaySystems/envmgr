resource "rafay_repositories" "metallb_repository" {

  metadata {
    name    = "metallb"
    project = var.project_name
  }
  
  spec {
    endpoint = "https://metallb.github.io/metallb"
    type     = "Helm"
  }
}


resource "rafay_catalog" "metallb_custom_catalog" {
  depends_on = [rafay_repositories.metallb_repository]
  metadata {
    name    = "metallb"
    project = var.project_name
  }
  spec {
    auto_sync  = true
    repository = rafay_repositories.metallb_repository.metadata.0.name
    type       = "HelmRepository"
  }
}

resource "rafay_namespace" "metallb_namespace" {
  depends_on = [rafay_catalog.metallb_custom_catalog]
  metadata {
    name    = "metallb-system"
    project = var.project_name
  }
  spec {
    drift {
      enabled = true
    }
  }
}

resource "rafay_addon" "metallb" {
  depends_on = [rafay_namespace.metallb_namespace]
  metadata {
    name    = "metallb"
    project = var.project_name
  }
  spec {
    namespace = "metallb-system"
	version = "v1"
    artifact {
      type = "Helm"
      artifact {
        catalog    = "metallb"
        chart_name = "metallb"
      }
    }
  }
}


resource "local_file" "metallb_values" {
  depends_on = [rafay_namespace.metallb_namespace]
  content = templatefile("${path.module}/templates/metallb-config.tftpl", {
    iprange = var.iprange[0]
  })
  filename        = "metallb-config.yaml"
  file_permission = "0666"
}



resource "local_file" "rafay_mks_cluter_spec" {
  depends_on = [random_id.rnd]
  content = templatefile("${path.module}/templates/rafay-mks.tftpl", {
    cluster_name   = "${local.uniquename}-cluster"
    private_ip     = var.private_ip
    public_ip      = var.public_ip
    hostname       = var.hostname
    server_count   = var.server_count
    project_name   = var.project_name
    k8s_version    = var.k8s_version
	blueprint_name = var.blueprint_name
    rafay_location = "${lookup(var.location_mapping, var.rafay_location)}"
  })
  filename        = "${local.uniquename}-${random_id.rnd.hex}-rafay-spec.yaml"
  file_permission = "0644"
}



resource "rafay_addon" "metallb-config" {
  depends_on = [local_file.metallb_values]
  metadata {
    name    = "metallb-config"
    project = var.project_name
  }
  spec {
    namespace = "metallb-system"
	version = "v1"
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://metallb-config.yaml"
        }
      }
    }
  }
}

resource "rafay_blueprint" "blueprint" {
  depends_on = [rafay_addon.metallb-config, rafay_addon.metallb]
  metadata {
    name    = "metallb"
    project = var.project_name
  }
  spec {
    version = "v1"
    base {
      name    = "default"
      version = "2.3.0"
    }
    custom_addons {
      name = "metallb"
      version = "v1"
    }
    custom_addons {
      depends_on = ["metallb"]
      name = "metallb-config"
      version = "v1"
    }
    drift {
      action  = "Deny"
      enabled = true
    }
    sharing {
      enabled = false
    }
    namespace_config {
      sync_type = "managed"
      enable_sync = true
    }
  }
 }