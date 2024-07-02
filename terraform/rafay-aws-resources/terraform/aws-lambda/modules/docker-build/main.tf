module "terraform-aws-lambda" {
  source  = "terraform-aws-lambda//modules/docker-build"
  version = "7.7.0"

  create_ecr_repo = var.create_ecr_repo
  create_sam_metadata = var.create_sam_metadata
  use_image_tag = var.use_image_tag
  ecr_address = var.ecr_address
  ecr_repo = var.ecr_repo
  image_tag = var.image_tag
  source_path = var.source_path
  docker_file_path = var.docker_file_path
  image_tag_mutability = var.image_tag_mutability
  scan_on_push = var.scan_on_push
  ecr_force_delete = var.ecr_force_delete
  ecr_repo_tags = var.ecr_repo_tags
  build_args = var.build_args
  ecr_repo_lifecycle_policy = var.ecr_repo_lifecycle_policy
  keep_remotely = var.keep_remotely
  platform = var.platform
  force_remove = var.force_remove
  keep_locally = var.keep_locally
  triggers = var.triggers
}
