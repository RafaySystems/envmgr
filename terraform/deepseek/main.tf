variable "enable_deep_seek_gpu" {
  description = "Enable DeepSeek using GPUs"
  type        = bool
  default     = false
}

variable "enable_deep_seek_neuron" {
  description = "Enable DeepSeek using Neuron"
  type        = bool
  default     = false
}

variable "enable_auto_mode_node_pool" {
  description = "Enable EKS AutoMode NodePool"
  type        = bool
  default     = false
}

locals {
  region   = "us-west-2"
  vpc_cidr = "10.0.0.0/16"
  name     = "eks-automode5"
#  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint = local.name
    email = "tim@rafay.co"
    env = "prod"
  }
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = "local.name"
  output_folder_path = "/tmp"
  filename           = "kubeconfig"
}

resource "null_resource" "create_file" {
  provisioner "local-exec" {
    command = "ls /tmp"
  }
depends_on = [rafay_download_kubeconfig.tfkubeconfig]
}

data "local_file" "kubeconfig" {
  filename = "/tmp/kubeconfig"
depends_on = [rafay_download_kubeconfig.tfkubeconfig]
}

output "kubeconfig" {
  value = data.local_file.kubeconfig.content
}
