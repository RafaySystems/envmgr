# resource "aws_iam_role" "karpenter_role" {
#   name = "${var.cluster_name}-${var.role_name}"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
#   managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#     "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#     "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
#   "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
# }

# resource "aws_iam_instance_profile" "test_profile" {
#   name = "${var.cluster_name}-${var.role_name}"
#   role = aws_iam_role.karpenter_role.name
# }

# resource "aws_iam_policy" "karpenter_policy" {
#   name = "${var.cluster_name}-${var.policy_name}"
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = [
#           "ec2:CreateLaunchTemplate",
#           "ec2:CreateFleet",
#           "ec2:RunInstances",
#           "ec2:CreateTags",
#           "iam:PassRole",
#           "ec2:TerminateInstances",
#           "ec2:DescribeLaunchTemplates",
#           "ec2:DescribeInstances",
#           "ec2:DescribeSecurityGroups",
#           "ec2:DescribeSubnets",
#           "ec2:DescribeInstanceTypes",
#           "ec2:DescribeInstanceTypeOfferings",
#           "ec2:DescribeAvailabilityZones",
#           "ssm:GetParameter",
#           "eks:DescribeCluster",
#           "ec2:DescribeImages",
#           "ec2:DescribeSpotPriceHistory",
#           "ec2:DeleteLaunchTemplate",
#           "iam:GetInstanceProfile",
#           "iam:CreateInstanceProfile",
#           "iam:DeleteInstanceProfile",
#           "iam:TagInstanceProfile",
#           "iam:AddRoleToInstanceProfile",
#           "iam:RemoveRoleFromInstanceProfile",
#           "pricing:GetProducts",
#           "pricing:DescribeServices",
#           "pricing:GetAttributeValues",
#         ],
#         Resource = "*",
#         Effect   = "Allow"
#       }
#     ]
#   })
# }

locals {
  rolearn = var.account_id != "" && var.linked_role_arn != "" ? format("arn:aws:iam::%s:role/%s", var.account_id, var.linked_role_arn) : null
}

resource "rafay_eks_cluster" "eks-cluster" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project
      #labels  = try(var.cluster_labels, null)
      labels = merge({
      "cluster-name" = var.cluster_name })
    }
    spec {
      type                   = "eks"
      blueprint              = var.blueprint_name
      blueprint_version      = var.blueprint_version
      cloud_provider         = var.cloud_credentials_name
      cross_account_role_arn = try(local.rolearn, null)
      cni_provider           = "aws-cni"
      # system_components_placement {
      #   node_selector = var.node_selector
      #   dynamic "tolerations" {
      #     for_each = var.tolerations
      #     content {
      #       effect   = tolerations.value.effect
      #       key      = tolerations.value.key
      #       operator = tolerations.value.operator
      #     }

      #   }
      # }
    }
  }
  cluster_config {
    apiversion = "rafay.io/v1alpha5"
    kind       = "ClusterConfig"
    metadata {
      name    = var.cluster_name
      region  = var.region
      version = var.k8s_version
      tags = merge({
        "cluster-name" = var.cluster_name },
      var.tags)
      #tags    = try(var.tags, null)
    }
    iam {
      service_role_arn = try(var.service_role_arn, null)
      with_oidc        = true
      service_accounts {
        metadata {
          name      = "karpenter"
          namespace = "karpenter"
        }
        attach_policy_arns = [resource.aws_iam_policy.karpenter_policy.arn]
      }
    }
    addons {
      name    = "aws-ebs-csi-driver"
      version = "latest"
    }
    addons {
      name    = "vpc-cni"
      version = "latest"
    }
    addons {
      name    = "kube-proxy"
      version = "latest"
    }
    addons {
      name    = "coredns"
      version = "latest"
    }
    identity_mappings {
      arns {
        arn      = resource.aws_iam_role.karpenter_role.arn
        group    = ["system:bootstrappers", "system:nodes"]
        username = "system:node:{{EC2PrivateDNSName}}"
      }
    }
    vpc {
      cluster_endpoints {
        private_access = true
        public_access  = false
      }
      nat {
        gateway = "Single"
      }
      cidr = var.create_vpc ? var.vpc_cidr : null

      dynamic "subnets" {
        for_each = var.create_vpc ? [] : [var.create_vpc]
        content {
          dynamic "private" {
            for_each = length(var.private_subnets) > 0 ? toset(var.private_subnets) : []
            content {
              name = private.value
              id   = private.value
            }
          }
          dynamic "public" {
            for_each = length(var.public_subnets) > 0 ? toset(var.public_subnets) : []
            content {
              name = public.value
              id   = public.value
            }
          }
        }
      }
    }
    dynamic "managed_nodegroups" {
      for_each = var.managed_nodegroups
      content {
        name               = managed_nodegroups.key
        instance_type      = managed_nodegroups.value.instance_type
        desired_capacity   = managed_nodegroups.value.node_count
        min_size           = managed_nodegroups.value.min_size
        max_size           = managed_nodegroups.value.max_size
        volume_size        = 80
        volume_type        = "gp3"
        version            = managed_nodegroups.value.k8s_version
        ami_family         = managed_nodegroups.value.ami_family
        private_networking = managed_nodegroups.value.private_networking
        volume_encrypted   = managed_nodegroups.value.volume_encrypted
        dynamic "iam" {
          for_each = managed_nodegroups.value.instance_role_arn == null ? [] : [managed_nodegroups.value.instance_role_arn]
          content {
            instance_role_arn = iam.value
          }
        }
        # dynamic "taints" {
        #   for_each = managed_nodegroups.value.taints
        #   content {
        #     effect = taints.value.effect
        #     key    = taints.value.key
        #   }
        # }
        tags   = try(managed_nodegroups.value.tags, null)
        labels = try(managed_nodegroups.value.labels, null)
      }
    }
  }
}
