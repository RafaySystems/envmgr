data "external" "get_rollback_release" {
  program = ["bash", "./get-workload-current-release.sh", "${var.sanity_workload_name}", "${var.sanity_project}", "${var.revision}"]
}

# resource "null_resource" "get_rollback_release" {
#   triggers = {
#     always_run = timestamp()
#   }
#   provisioner "local-exec" {
#     interpreter = ["/bin/bash", "-c"]
#     command     = "chmod +x ./get-workload-current-release.sh; ./get-workload-current-release.sh"
#     environment = {
#       WORKLOAD_NAME = "${var.workload_name}"
#       PROJECT_NAME = "${var.project_name}"
#       NEW_RELEASE_BRANCH = "${var.new_release_branch}"
#     }
#   }
# }
