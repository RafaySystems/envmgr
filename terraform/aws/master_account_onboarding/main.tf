###############################################
### Read uuid from parameter store          ###
###############################################

# data "aws_ssm_parameter" "uuid" {
#   name = "/rafay/uuid"
# }

resource "random_uuid" "external_id" {
}


###############################################################################
## Configure Rafay cloud credentials with this role for cross account access ##
###############################################################################

resource "aws_iam_role" "master-cluster-role" {
  name               = "master-cross-account-rafay-cluster-role"
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.rafay_account}:root"
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": "${random_uuid.external_id.result}"
                }
            }
        }
    ]
  }
  EOF
  inline_policy {
    name = "master-cross-account-rafay-cluster-policy"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "iam:ListPolicyVersions",
            "iam:GetPolicy",
            "iam:GetPolicyVersion",
            "iam:ListAttachedRolePolicies"
          ],
          Resource = "*",
          Effect   = "Allow"
        },
        {
          Action   = ["sts:AssumeRole"],
          Resource = "arn:aws:iam::*:role/rafay-linked-account-cluster-role",
          Effect   = "Allow"
        }
      ]
    })
  }
}


######################################################################
## Rafay Cloud Credentials                                          ##
######################################################################
resource "rafay_cloud_credentials_v3" "tftestcredentials" {
  metadata {
    name    = "rafay-master-cross-account-role"
    project = var.project
  }
  spec {
    type     = "ClusterProvisioning"
    provider = "aws"
    credentials {
      type        = "Role"
      arn         = resource.aws_iam_role.master-cluster-role.arn
      external_id = random_uuid.external_id.result
      account_id  = var.rafay_account
    }
    sharing {
      enabled = false
    }
  }
}
