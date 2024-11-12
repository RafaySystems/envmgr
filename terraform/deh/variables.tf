variable "image" {
  default="registry.dell.huggingface.co/enterprise-dell-inference-meta-llama-meta-llama-3.1-8b-instruct"
}

variable "ingress_domain" {
  default = "notebook.dev.rafay-edge.net"
}

variable "name" {}
variable "project" {}
variable "username" {}
variable "cluster_name" {
    default = "dell-ai-cluster1"
}
variable "route53_zone_id" {
    default="Z06542572EP0CEJWIKH3"
}
variable "rafay_rest_endpoint" {
  default = "dell.rafay.dev"
}

variable "cpu_request" {
    default = "1"
}
variable "memory_request" {
    default = "4Gi"
}
variable "cpu_limit" {
    default = "4"
}
variable "memory_limit" {
    default = "8Gi"
}
variable "num_gpus" {
    default = "1"
}

variable "ingress_controller_ips" {
    default = ["192.168.198.227"]
}

variable "gpu_profile" {
    default = "NVIDIA-H100-80GB-HBM3"
}

variable "model" {
    default = "meta-llama--Meta-Llama-3.1-8b-Instruct"
}
