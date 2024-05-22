variable "rafay_spec" {
  description = "Rafay JSON/YAML specification"
  type        = any
  nullable    = false

  validation {
    condition = alltrue([
      var.rafay_spec.kind != null,
      var.rafay_spec.kind != "",
      var.rafay_spec.metadata != null,
      var.rafay_spec.metadata.name != null,
      var.rafay_spec.metadata.name != "",
      var.rafay_spec.metadata.project != null,
      var.rafay_spec.metadata.project != "",
      var.rafay_spec.spec != null,
    ])
    error_message = "Not a valid Rafay specification."
  }
}

resource "random_id" "rafay_spec_file_suffix" {
  byte_length = 4
}

resource "local_file" "rafay_spec" {
  content         = jsonencode(var.rafay_spec)
  filename        = "rafay-spec-${random_id.rafay_spec_file_suffix.hex}.json"
  file_permission = "0600"
}

resource "terraform_data" "rctl_apply" {
  triggers_replace = [
    local_file.rafay_spec.content,
    local_file.rafay_spec.filename
  ]

  # Run rctl apply when the YAML file changes or is created
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = "./apply.sh"
    environment = {
      "FILE_NAME" = local_file.rafay_spec.filename
    }
  }
}

resource "terraform_data" "rctl_delete" {
  input = {
    kind                 = lower(var.rafay_spec.kind)
    name                 = var.rafay_spec.metadata.name
    project              = var.rafay_spec.metadata.project
  }

  # Run rctl delete when `terraform destroy` is called
  provisioner "local-exec" {
    when        = destroy
    interpreter = ["/bin/sh", "-c"]
    command     = "./delete.sh"
    environment = {
      "KIND"    = self.input.kind
      "NAME"    = self.input.name
      "PROJECT" = self.input.project
    }
  }
}
