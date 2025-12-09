variable "cluster_name" {
  type        = string
  description = "Rafay MKS cluster name"
}

variable "project_name" {
  type        = string
  description = "Rafay project name"
}

variable "namespace" {
  type        = string
  default     = "runai"
  description = "Kubernetes namespace for Run:AI"
}

variable "nodes_information" {
  type = object({
    nodes_info = map(object({
      hostname         = string
      ip_address       = string
      operating_system = string
      private_ip       = string
    }))
    number_of_nodes = number
  })
  description = "Output from res-upstream-infra-device terraform with nodes information"

  default = {
    nodes_info      = {}
    number_of_nodes = 0
  }
}

variable "runai_chart_version" {
  type        = string
  default     = "2.23.17"
  description = "Run:AI Helm chart version"
}

variable "runai_helm_repo" {
  type        = string
  default     = "https://runai.jfrog.io/artifactory/api/helm/run-ai-charts"
  description = "Run:AI Helm repository URL"
}

variable "user_email" {
  type        = string
  description = "Email for the Run:AI user to be created (will have cluster-scoped Administrator access)"
}

variable "dns_domain" {
  type        = string
  default     = "runai.langgoose.com"
  description = "Base DNS domain for Run:AI clusters"
}

variable "route53_zone_id" {
  type        = string
  description = "AWS Route53 hosted zone ID"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for Route53 operations (Route53 is global, but provider needs a region)"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email for Let's Encrypt certificate notifications"
}

variable "cluster_issuer_name" {
  type        = string
  default     = "letsencrypt-prod"
  description = "Name of the cert-manager ClusterIssuer"
}

variable "rafay_triggered_by" {
  type        = string
  default     = ""
  description = "Optional: User who triggered the deployment (from Rafay)"
}
