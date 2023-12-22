variable "cluster_name" {
    default = "sashi-ai-eks"
}
variable "region" {
    default = "us-east-1"
}
variable "namespace" {
   default = "aienv"
}
variable "service-account-name" {
    default = "bedrock"
}

variable "jupyter_admin_password" {
    default = "Jupyt3r"
}