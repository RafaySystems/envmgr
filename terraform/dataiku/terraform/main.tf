resource "local_file" "ssh_key" {
  filename = "${path.module}/temp_id_rsa"
  content  = var.ssh_private_key
  file_permission = "0600"
}

resource "null_resource" "create_remote_license_file" {
  provisioner "remote-exec" {
    inline = [
      "echo '${var.dataiku_license}' > /home/dataiku/license.json"
    ]

    connection {
      host        = var.remote_host
      user        = var.remote_user
      private_key = file(local_file.ssh_key.filename)
    }
  }
}

resource "null_resource" "remote_exec" {
  provisioner "file" {
    source      = "install.sh"
    destination = "/tmp/install.sh"

    connection {
      type        = "ssh"
      host        = var.remote_host
      user        = var.remote_user
      private_key = file(local_file.ssh_key.filename)
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
      private_key = file(local_file.ssh_key.filename)
    }
  }
}
