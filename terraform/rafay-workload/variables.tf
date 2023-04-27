

variable "workload_name" {
  description = "name of the workload"
  default = "django-app"
}

variable "workload_namespace" {
  description = "name of the namespace"
  default = "testnamespace"
}

variable "workload_project" {
  description = "name of the project"
  default = "testproject"
}

variable "cluster_name" {
  description = "cluster namespace"
  default = "cluster-1"
}

variable "workload_helm_gitrepo" {
  default = "envmgr-demo"
}

variable "workload_helm_gitrepo_revision" {
  default = "fmac"
}

variable "workload_helm_chart_path" {
  default = "django-app-0.1.0.tgz"
}

variable "workload_helm_chart_values_path" {
  default = "django-app-values.yaml"
}



