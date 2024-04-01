#resource "rafay_cloud_credential" "aws_creds" {
#  name         = var.aws_cloud_provider_name
#  project      = var.eks_cluster_project
#  description  = "description"
#  type         = "cluster-provisioning"
#  providertype = "AWS"
#  awscredtype  = "accesskey"
#  accesskey    = var.aws_cloud_provider_access_key
#  secretkey    = var.aws_cloud_provider_secret_key
#}

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
      cloud_provider = var.cloud_credential_name
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
        email = var.username
      }
    }
    vpc {
      cidr = "192.168.0.0/16"
      cluster_endpoints {
        private_access = true
        public_access  = var.eks_cluster_public_access
      }
      nat {
        gateway = "Single"
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
      desired_capacity = var.node_count
      min_size         = 1
      max_size         = var.node_count
      max_pods_per_node = 50
      version          = var.eks_cluster_version
      volume_size      = 80
      volume_type      = "gp3"
      private_networking = true
      labels = {
        app = "infra"
        dedicated = "true"
      }
      tags = {
        env = "dev"
        email = var.username
      }
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

resource "rafay_group" "group" {
  name        = "${var.eks_cluster_name}-group"
}

resource "rafay_groupassociation" "groupassociation" {
  depends_on = [rafay_group.group]
  project = "${var.eks_cluster_project}"
  group = "${rafay_group.group.name}"
  roles = ["CLUSTER_ADMIN"]
  add_users = ["${var.username}"]
  idp_user = var.user_type
}

resource "rafay_groupassociation" "groupassociation_collaborators" {
  count = var.collaborator == "user_email" ? 0 : 1
  depends_on = [rafay_groupassociation.groupassociation]
  project = "${var.eks_cluster_project}"
  roles = ["CLUSTER_ADMIN"]
  group = "${rafay_group.group.name}"
  add_users = ["${var.collaborator}"]
  idp_user = true
}