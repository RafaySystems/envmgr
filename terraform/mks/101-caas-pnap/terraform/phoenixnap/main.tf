resource "pnap_ip_block" "ip-block" {
  location        = var.location
  cidr_block_size = "/${var.cidr_block_size}"
}


# Create a public network
resource "pnap_public_network" "Public-Network" {
  name     = "${var.cluster_name}-${var.total_instances}"
  location = var.location
  ip_blocks {
    public_network_ip_block {
      id = pnap_ip_block.ip-block.id
    }
  }
}

resource "pnap_server" "rafay_server" {
  count                    = var.total_instances
  hostname                 = "${var.cluster_name}-${var.total_instances"
  os                       = var.os
  type                     = var.type
  location                 = var.location
  network_type             = "USER_DEFINED"
  install_default_ssh_keys = true
  cloud_init {
    user_data = "I2Nsb3VkLWNvbmZpZwpwYWNrYWdlczoKICAtIGJ6aXAyCiAgLSB3Z2V0CndyaXRlX2ZpbGVzOgotIGVuY29kaW5nOiA2NAogIGNvbnRlbnQ6IEl5RXZZbWx1TDJKaGMyZ0tDbWxtSUhSbGMzUWdMV1lnTDJWMFl5OWpaWFJ2Y3kxeVpXeGxZWE5sT3lCMGFHVnVDaUFnYzNWa2J5QnplWE4wWlcxamRHd2djM1J2Y0NCbWFYSmxkMkZzYkdRdWMyVnlkbWxqWlFvZ0lITjFaRzhnYzNsemRHVnRZM1JzSUdScGMyRmliR1VnWm1seVpYZGhiR3hrTG5ObGNuWnBZMlVLWld4elpRb2dJSE4xWkc4Z2FYQjBZV0pzWlhNZ0xVWUtJQ0J6ZFdSdklHRndkQ0J5WlcxdmRtVWdMWGx4SUdsd2RHRmliR1Z6TFhCbGNuTnBjM1JsYm5RZ0xTMXdkWEpuWlFwbWFRb0sKICBwYXRoOiAvb3B0L3NldHVwLnNoCiAgcGVybWlzc2lvbjogJzA3NzUnCnJ1bmNtZDoKIC0gc3VkbyBiYXNoIC9vcHQvc2V0dXAuc2gK"
  }
  network_configuration {
    public_network_configuration {
      public_networks {
        server_public_network {
          id  = pnap_public_network.Public-Network.id
          ips = [cidrhost(pnap_ip_block.ip-block.cidr, "${count.index}" + 2)]
        }
      }
    }
    private_network_configuration {
      configuration_type = "USE_OR_CREATE_DEFAULT"
    }
  }
}
