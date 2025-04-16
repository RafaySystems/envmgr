provider "aws" {
  region = var.region
}

locals {
  sanitized_username = replace(var.username, "@", "_")
}

resource "aws_iam_policy" "sagemaker_user_policy" {
  name        = "SageMakerUserPolicy-${local.sanitized_username}"
  description = "Policy for SageMaker Users"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AmazonSageMakerPresignedUrlDenyPolicy"
        Effect = "Deny"
        Action = [
          "sagemaker:CreatePresignedDomainUrl"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "sagemaker:ResourceTag/studiouserid" = "$${aws:username}"
          }
        }
      },
      {
        Sid    = "AmazonSageMakerPresignedUrlAllowPolicy"
        Effect = "Allow"
        Action = [
          "sagemaker:CreatePresignedDomainUrl"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  user       =  local.sanitized_username
  policy_arn = aws_iam_policy.sagemaker_user_policy.arn 
}


resource "aws_sagemaker_user_profile" "sagemaker_user_profile" {
  user_profile_name =  local.sanitized_username
  domain_id         = var.domain_id
  
  user_settings {
  
    execution_role    = var.execution_role_arn
  }
  tags = {
    "studiouserid"  = var.username
  }
}

