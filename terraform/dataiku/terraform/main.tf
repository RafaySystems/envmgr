resource "null_resource" "remote_exec" {
  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"

    connection {
      type        = "ssh"
      host        = var.remote_host
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install.sh",
      "sudo /tmp/install.sh"
    ]

    connection {
      type        = "ssh"
      host        = var.remote_host
      user        = var.remote_user
      private_key = file(var.private_key_path)
    }
  }
}
