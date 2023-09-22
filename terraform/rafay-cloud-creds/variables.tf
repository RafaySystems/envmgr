
variable "aws_cloud_provider_name" {
  description = "cloud credentials name"
  default = "aws-cloud-creds-1"
}

variable "aws_cloud_provider_access_key" {
  description = "aws access key"
  default = ""
  sensitive = true
}

variable "aws_cloud_provider_secret_key" {
  description = "aws secret key"
  default = ""
  sensitive = true
}

variable "aws_cloud_provider_project" {
  description = "name of the project"
  default = "testproject"
}

