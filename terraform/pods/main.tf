resource "random_integer" "port" {
  min = 2000
  max = 30000
}

locals {
  pod_name = "ubuntu-${random_integer.port.result}"
}

resource "local_file" "ssh_key" {
  filename = "${path.module}/temp_id_rsa"
  content  = var.ssh_private_key
  file_permission = "0600"
}

resource "null_resource" "create_pod" {
  depends_on = [local_file.ssh_key]
  provisioner "remote-exec" {
    inline = [
      # Run the container
      "sudo docker run -dit --name ${local.pod_name} -p ${random_integer.port.result}:22 ubuntu:22.04",

      # Wait for container to start
      "sleep 5",

      # Update & install SSH
      "sudo docker exec ${local.pod_name} apt update",
      "sudo docker exec ${local.pod_name} apt install -y openssh-server",

      # Prepare SSH service
      "sudo docker exec ${local.pod_name} mkdir -p /var/run/sshd",
      "sudo docker exec ${local.pod_name} service ssh start",

      # Create ubuntu user and password
      "sudo docker exec ${local.pod_name} bash -c \"useradd -m -s /bin/bash ubuntu && echo 'ubuntu:password' | chpasswd\"",

      # Setup SSH keys
      "sudo docker exec ${local.pod_name} mkdir -p /home/ubuntu/.ssh",
      "sudo docker exec ${local.pod_name} chmod 700 /home/ubuntu/.ssh",
      "sudo docker exec ${local.pod_name} bash -c 'echo \"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDArCqS9QWsOYG+CpQD/tXk0mGwUs1yVEOaCC+CRyyU6uoZ3BDv5jscCtRczc4gczNpuSt3tmajxqgA4xG7pDPTXR3vpGjBf8E8UWB1VgPOugNhcMcZ2RWkZm3jsbmAilmXpHJSzn2hA+5Lu7WYEHccViqTAMH/JEv86NU+7bqABYtG8/70UrFvCz8vco4vlEyW6mvqEZcUTxHwGHXLF4dOZgOn3h5ZBJ9oCMynX/I8yZGK0gj5EmOJzscKoqTSTdpGKXVi7FiKzYUoN7L18FwqUX92EpzbqyvRrlnldRvZAg2t04P8ZktHL8kApF+5lyRd8Dlj/WPJ7/qzgSVtrKy3 ssh-key-2022-12-06\" > /home/ubuntu/.ssh/authorized_keys'",
      "sudo docker exec ${local.pod_name} chmod 600 /home/ubuntu/.ssh/authorized_keys",
      "sudo docker exec ${local.pod_name} chown -R ubuntu:ubuntu /home/ubuntu/.ssh",

      # Modify SSH config
      "sudo docker exec ${local.pod_name} sed -i 's/^#\\?\\(PubkeyAuthentication\\).*/\\1 yes/' /etc/ssh/sshd_config",
      "sudo docker exec ${local.pod_name} sed -i 's/^#\\?\\(PasswordAuthentication\\).*/\\1 no/' /etc/ssh/sshd_config",
      "sudo docker exec ${local.pod_name} sed -i 's/^#\\?\\(PermitRootLogin\\).*/\\1 no/' /etc/ssh/sshd_config",

      # Restart SSH
      "sudo docker exec ${local.pod_name} service ssh restart"
    ]

    connection {
      host        = var.remote_host
      user        = var.remote_user
      private_key = file(local_file.ssh_key.filename)
    }
  }
}

#resource "null_resource" "destroy_pod" {
#  depends_on = [local_file.ssh_key]
#
#  triggers = {
#    always_run = timestamp()
#  }
#
#  provisioner "local-exec" {
#    when    = destroy
#    command = "ssh -o StrictHostKeyChecking=no -i ${local_file.ssh_key.filename} ${var.remote_user}@${var.remote_host} 'sudo docker rm -f ${local.pod_name} || true'"
#  }
#}
