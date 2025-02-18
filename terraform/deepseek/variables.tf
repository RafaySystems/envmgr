variable "region" {
  type        = string
  default = "us-west-2"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "blueprint" {
  type        = string
  description = "Blueprint to use"
}

variable "blueprint_version" {
  type        = string
  description = "Version of the blueprint"
}
