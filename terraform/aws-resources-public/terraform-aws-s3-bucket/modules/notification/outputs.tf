output "s3_bucket_notification_id" {
  description = "ID of S3 bucket"
  value       = module.terraform-aws-s3-bucket.s3_bucket_notification_id
}

