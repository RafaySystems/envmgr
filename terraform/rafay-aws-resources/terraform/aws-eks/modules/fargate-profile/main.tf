module "terraform-aws-eks" {
  source  = "terraform-aws-eks//modules/fargate-profile"
  version = "20.14.0"

  create = var.create
  tags = var.tags
  create_iam_role = var.create_iam_role
  cluster_ip_family = var.cluster_ip_family
  iam_role_arn = var.iam_role_arn
  iam_role_name = var.iam_role_name
  iam_role_use_name_prefix = var.iam_role_use_name_prefix
  iam_role_path = var.iam_role_path
  iam_role_description = var.iam_role_description
  iam_role_permissions_boundary = var.iam_role_permissions_boundary
  iam_role_attach_cni_policy = var.iam_role_attach_cni_policy
  iam_role_additional_policies = var.iam_role_additional_policies
  iam_role_tags = var.iam_role_tags
  cluster_name = var.cluster_name
  name = var.name
  subnet_ids = var.subnet_ids
  selectors = var.selectors
  timeouts = var.timeouts
}
