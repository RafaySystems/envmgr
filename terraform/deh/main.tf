resource "random_string" "resource_code" {
  length  = 4
  special = false
  upper   = false
  keepers = {
    id = "${file("deh.yaml")}"
  }
}

resource "local_file" "deh_yaml" {
  content = templatefile("templates/deh.tftpl", {
    image  = var.image
    model  = var.model
    ingress_host = "${var.name}.${var.ingress_domain}"
    cpu_request = var.cpu_request
    memory_request = var.memory_request
    cpu_limit = var.cpu_limit
    memory_limit = var.memory_limit
    gpu_limit = var.num_gpus
    name      = var.name
  })
  filename = "deh.yaml"
}

provider "aws" {
  region  = "us-west-2"
}


resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.name
    project = var.project
  }
  spec {
    drift {
      enabled = false
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_workload" "deh" {
  metadata {
    name    = var.name
    project = var.project
  }
  spec {
    namespace = var.name
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
    version = "v-${random_string.resource_code.result}"
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://deh.yaml"
        }
      }
    }
  }
}

resource "aws_route53_record" "deh" {
  zone_id = var.route53_zone_id
  name    = "${var.name}.${var.ingress_domain}"
  type    = "A"
  ttl     = 300
  records = [var.ingress_controller_ips]
}

