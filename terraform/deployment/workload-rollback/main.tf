locals {
  version = timestamp()
}

resource "local_file" "workload_spec" {
  content = templatefile("${path.module}/templates/workload.tftpl", {
    workload_name   = var.sanity_workload_name
    project_name   = var.sanity_project
    namespace   = var.ns_name
    gitrepo_name   = var.values_repo
    workload_release_branch   = var.workload_rollback_release_branch
    app_catalog = var.catalog
    helm_chart_name   = var.chart
    helm_chart_version   = var.chart_version
    custom_value_path   = var.custom_value_path
    deployment_group   = var.sanity_phase
    random_id   = local.version
  })
  filename        = "${var.sanity_workload_name}-spec.yaml"
  file_permission = "0644"
}

resource "null_resource" "apply_workload" {
  triggers = {
    always_run = timestamp()
  }
  count = var.rollback != "false" ? 1 : 0
  depends_on = [local_file.workload_spec]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./apply_workload.sh; ./apply_workload.sh"
    environment = {
      filename = local_file.workload_spec.filename
      WORKLOAD_NAME = "${var.sanity_workload_name}"
      PROJECT_NAME = "${var.sanity_project}"
    }
  }
}
