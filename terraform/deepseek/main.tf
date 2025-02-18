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
  name     = "eks-automode4"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint = local.name
    email = "tim@rafay.co"
    env = "prod"
  }
}

# Define the required providers
provider "aws" {
  region = local.region # Change to your desired region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

data "aws_availability_zones" "available" {
  # Do not include local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Use the Terraform VPC module to create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.17.0" # Use the latest version available

  name = "${local.name}-vpc"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

# Use the Terraform EKS module to create an EKS cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1" # Use the latest version available

  cluster_name    = local.name
  cluster_version = "1.31" # Specify the EKS version you want to use

  cluster_endpoint_public_access           = true
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = local.tags
}


resource "aws_ecr_repository" "chatbot-ecr" {
  name                 = "${local.name}-chatbot"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "neuron-ecr" {
  name                 = "${local.name}-neuron-base"
  image_tag_mutability = "MUTABLE"
}

# Outputs
output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}

output "ecr_repository_uri" {
  value = aws_ecr_repository.chatbot-ecr.repository_url
}

output "ecr_repository_uri_neuron" {
  value = aws_ecr_repository.neuron-ecr.repository_url
}


resource "rafay_import_cluster" "import_cluster" {
  depends_on = [module.eks]
  clustername           = var.cluster_name
  projectname           = var.project_name
  blueprint             = var.blueprint
  blueprint_version     = var.blueprint_version
  kubernetes_provider   = "EKS"
  provision_environment = "CLOUD"
  values_path           = "values.yaml"

  lifecycle {
    ignore_changes = [
      bootstrap_path,
      values_path
    ]
  }
}
resource "helm_release" "v2-infra" {
  depends_on = [rafay_import_cluster.import_cluster]

  name             = "v2-infra"
  namespace        = "rafay-system"
  create_namespace = true
  repository       = "https://rafaysystems.github.io/rafay-helm-charts/"
  chart            = "v2-infra"
  values           = [rafay_import_cluster.import_cluster.values_data]
  version          = "1.1.2"

  lifecycle {
    ignore_changes = [
      # Avoid reapplying helm release
      values,
      # Prevent reapplying if version changes
      version
    ]
  }
}

resource "null_resource" "delete-webhook" {
  triggers = {
    cluster_name = var.cluster_name
    project_name = var.project_name
  }

  provisioner "local-exec" {
    when    = destroy
    command = "chmod +x ./delete-webhook.sh && ./delete-webhook.sh"
    environment = {
      CLUSTER_NAME = "${self.triggers.cluster_name}"
      PROJECT      = "${self.triggers.project_name}"
    }
  }

  depends_on = [helm_release.v2-infra]
}
