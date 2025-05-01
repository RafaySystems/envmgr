variable "region" {
  default = "us-phoenix-1"
}

variable "compartment_ocid" {
  default = "ocid1.tenancy.oc1..aaaaaaaaaa3ghjcqbrbzmssbzhxzhxf24rpmuyxbaxwcj2axwoqkpd56ljkq"
}

variable "subnet_id" {
  default = "ocid1.subnet.oc1.phx.aaaaaaaayc55km233ex74dmqpjphdeeceay4prowcc5hcoq2mj3gol3hbkda"
}

variable "instance_shape" {
  default = "VM.Standard3.Flex"
}

variable "ssh_public_key" {
  default = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDArCqS9QWsOYG+CpQD/tXk0mGwUs1yVEOaCC+CRyyU6uoZ3BDv5jscCtRczc4gczNpuSt3tmajxqgA4xG7pDPTXR3vpGjBf8E8UWB1VgPOugNhcMcZ2RWkZm3jsbmAilmXpHJSzn2hA+5Lu7WYEHccViqTAMH/JEv86NU+7bqABYtG8/70UrFvCz8vco4vlEyW6mvqEZcUTxHwGHXLF4dOZgOn3h5ZBJ9oCMynX/I8yZGK0gj5EmOJzscKoqTSTdpGKXVi7FiKzYUoN7L18FwqUX92EpzbqyvRrlnldRvZAg2t04P8ZktHL8kApF+5lyRd8Dlj/WPJ7/qzgSVtrKy3 ssh-key-2022-12-06
EOF
}

variable "remote_host" {
  description = "Public IP or DNS of the remote server"
  type        = string
}

variable "remote_user" {
  description = "SSH username (e.g., ubuntu, root)"
  type        = string
  default     = "ubuntu"
}

variable "ssh_private_key" {
  description = "Contents of the private SSH key"
  type        = string
  sensitive   = true
}
