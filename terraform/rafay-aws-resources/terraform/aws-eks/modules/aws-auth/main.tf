module "terraform-aws-eks" {
  source  = "terraform-aws-eks//modules/aws-auth"
  version = "20.14.0"

  create = var.create
  create_aws_auth_configmap = var.create_aws_auth_configmap
  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  aws_auth_roles = var.aws_auth_roles
  aws_auth_users = var.aws_auth_users
  aws_auth_accounts = var.aws_auth_accounts
}
