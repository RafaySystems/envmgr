resource "rafay_cloud_credential" "aws_creds" {
  name         = var.aws_cloud_provider_name
  project      = var.eks_cluster_project
  description  = "description"
  type         = "cluster-provisioning"
  providertype = "AWS"
  awscredtype  = "accesskey"
  accesskey    = var.aws_cloud_provider_access_key
  secretkey    = var.aws_cloud_provider_secret_key
}

resource "rafay_eks_cluster" "ekscluster-basic" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.eks_cluster_name
      project = var.eks_cluster_project
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
      name    = var.eks_cluster_name
      region  = var.eks_cluster_region
      version = var.eks_cluster_version
      tags = {
        env = "dev"
        email = var.email_tag
      }
    }
    iam {
      with_oidc = true
      service_accounts {
        metadata {
          name = "test-irsa"
          namespace = "yaml1"
        }
        attach_policy = <<EOF
        {
          "Version": "2012-10-17",
          "Statement": [
            {
              "Effect": "Allow",
              "Action": "ec2:Describe*",
              "Resource": "*"
            },
            {
              "Effect": "Allow",
              "Action": "ec2:AttachVolume",
              "Resource": "*"
            },
            {
              "Effect": "Allow",
              "Action": "ec2:DetachVolume",
              "Resource": "*"
            },
            {
              "Effect": "Allow",
              "Action": ["elasticloadbalancing:*"],
              "Resource": ["*"]
            }
          ]
        }
        EOF
      }
    }


    vpc {
      subnets {
        dynamic "private" {
          for_each = var.eks_private_subnets

          content {
            name = private.value
            id = private.value
          }
        }
        dynamic "public" {
          for_each = var.eks_public_subnets

          content {
            name = public.value
            id = public.value
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
      instance_type    = var.eks_cluster_node_instance_type
      desired_capacity = 1
      min_size         = 1
      max_size         = 2
      max_pods_per_node = 50
      version          = var.eks_cluster_version
      volume_size      = 80
      volume_type      = "gp3"
      private_networking = true
      subnets = var.eks_private_subnets
      labels = {
        app = "infra"
        dedicated = "true"
      }
      tags = {
        env = "dev"
        email = var.email_tag
      }
    }
    addons {
      name = "aws-ebs-csi-driver"
      version = "latest" 
    }
    addons {
      name = "vpc-cni"
      version = "latest"
    }
    addons {
      name = "kube-proxy"
      version = "latest"
    }
    addons {
      name = "coredns"
      version = "latest"
    }
  }
}
