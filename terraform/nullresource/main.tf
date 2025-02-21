resource "null_resource" "example" {
  triggers = {
    always_update = timestamp() 
  }

  provisioner "local-exec" {
    command = "echo 'Null resource created!'"
    when    = create
  }

  provisioner "local-exec" {
    command = "echo 'Null resource destroyed!'"
    when    = destroy
  }
}