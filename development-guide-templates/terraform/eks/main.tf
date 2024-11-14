resource "rafay_cloud_credential" "aws_creds" {
  name         = var.aws_cloud_provider_name
  project      = var.project
  description  = "description"
  type         = "cluster-provisioning"
  providertype = "AWS"
  awscredtype  = "accesskey"
  accesskey    = var.aws_access_key_id
  secretkey    = var.aws_secret_access_key
}

resource "rafay_eks_cluster" "ekscluster-basic" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project
    }
    spec {
      type           = "eks"
      blueprint      = "default"
      cloud_provider = rafay_cloud_credential.aws_creds.name
      cni_provider   = "aws-cni"
      proxy_config   = {}
    }
  }
  cluster_config {
    apiversion = "rafay.io/v1alpha5"
    kind       = "ClusterConfig"
    metadata {
      name    = var.cluster_name
      region  = var.aws_region
      version = var.eks_cluster_version
      tags    = var.tags
    }
    vpc {
      subnets {
        dynamic "private" {
          for_each = var.eks_private_subnets

          content {
            name = private.value
            id   = private.value
          }
        }
        dynamic "public" {
          for_each = var.eks_public_subnets

          content {
            name = public.value
            id   = public.value
          }
        }
      }
      cluster_endpoints {
        private_access = true
        public_access  = var.eks_cluster_public_access
      }
    }
    node_groups {
      name       = "ng-1"
      ami_family = "AmazonLinux2"
      iam {
        iam_node_group_with_addon_policies {
          image_builder = true
          auto_scaler   = true
        }
      }
      instance_type      = var.eks_cluster_node_instance_type
      desired_capacity   = 1
      min_size           = 1
      max_size           = 2
      max_pods_per_node  = 50
      version            = var.eks_cluster_version
      volume_size        = 80
      volume_type        = "gp3"
      private_networking = true
      subnets            = var.eks_private_subnets
      labels = {
        app       = "infra"
        dedicated = "true"
      }
      tags = var.tags
    }
  }
}
