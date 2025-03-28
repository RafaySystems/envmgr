variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
}

variable "cluster_name" {
  type    = string
}

variable "namespace" {
  type    = string
}

variable "hserver" {
  description = "Kubeconfig server"
  type        = string
}

variable "clientcertificatedata" {
  description = "Kubeconfig client-certificate-data"
  type        = string
}

variable "clientkeydata" {
  description = "Kubeconfig client-key-data"
  type        = string
}

variable "certificateauthoritydata" {
  description = "Kubeconfig certificate-authority-data"
  type        = string
}