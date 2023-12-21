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

variable "backend-image" {
    default = "registry.dev.rafay-edge.net/rafay/rag-backend"
}

variable "backend-image-tag" {
    default = "v29"
}

variable "frontend-image" {
    default = "registry.dev.rafay-edge.net/rafay/rag-frontend"
}

variable "frontend-image-tag" {
    default = "v30"
}