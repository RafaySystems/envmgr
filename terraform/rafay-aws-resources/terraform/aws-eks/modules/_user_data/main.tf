module "terraform-aws-eks" {
  source  = "terraform-aws-eks//modules/_user_data"
  version = "20.14.0"

  create = var.create
  platform = var.platform
  ami_type = var.ami_type
  enable_bootstrap_user_data = var.enable_bootstrap_user_data
  is_eks_managed_node_group = var.is_eks_managed_node_group
  cluster_name = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  cluster_auth_base64 = var.cluster_auth_base64
  cluster_service_cidr = var.cluster_service_cidr
  cluster_ip_family = var.cluster_ip_family
  additional_cluster_dns_ips = var.additional_cluster_dns_ips
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
  pre_bootstrap_user_data = var.pre_bootstrap_user_data
  post_bootstrap_user_data = var.post_bootstrap_user_data
  bootstrap_extra_args = var.bootstrap_extra_args
  user_data_template_path = var.user_data_template_path
  cloudinit_pre_nodeadm = var.cloudinit_pre_nodeadm
  cloudinit_post_nodeadm = var.cloudinit_post_nodeadm
}
