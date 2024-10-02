resource "null_resource" "workload-test" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./workload-test.sh; ./workload-test.sh"
    environment = {
      url = var.url
    }
  }
}

data "local_file" "rollback" {
  filename   = "${path.module}/rollback"
  depends_on = ["null_resource.workload-test"]
}

data "local_file" "continue" {
  filename   = "${path.module}/continue"
  depends_on = ["null_resource.workload-test"]
}
