resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.workload_namespace
    project = var.workload_project
  }
  spec {
    drift {
      enabled = true
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_workload" "workload" {
  metadata {
    name    = var.workload_name
    project = var.workload_project
  }
  spec {
    namespace = var.workload_namespace
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v1"
    artifact {
      type = "Helm"
      artifact {
        chart_path {
          name = var.workload_helm_chart_path
        }
        values_paths {
          name = var.workload_helm_chart_values_path
        }
        repository = var.workload_helm_gitrepo
        revision   = var.workload_helm_gitrepo_revision
      }
      options {
        set_string = [
          "workloadName=${var.workload_name}",
          "projectName=${var.workload_project}",
          "environmentName=${var.workload_env}",
          "server.server.env.celeryBrokerUrl=redis://${var.redis_config_endpoint}:6379/0",
          "server.server.env.celeryResultBackend=redis://${var.redis_config_endpoint}:6379/0",
          "server.server.env.postgresHost=${var.postgres_host}",
          "server.server.env.postgresPassword=${var.postgres_password}",
          "server.server.env.postgresUser=${var.postgres_username}",
          "server.server.env.postgresPort=${var.postgres_port}",
          "worker.worker.env.celeryBrokerUrl=redis://${var.redis_config_endpoint}:6379/0",
          "worker.worker.env.celeryResultBackend=redis://${var.redis_config_endpoint}:6379/0",
          "worker.worker.env.postgresHost=${var.postgres_host}",
          "worker.worker.env.postgresPassword=${var.postgres_password}",
          "worker.worker.env.postgresUser=${var.postgres_username}",
          "worker.worker.env.postgresPort=${var.postgres_port}",
        ]
      }
    }
  }
}