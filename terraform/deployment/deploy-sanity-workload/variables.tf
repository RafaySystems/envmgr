variable "ns_name" {
  type    = string
  default = "wordpress"
}

variable "sanity_project" {
  type    = string
  default = "fleet"
}

variable "sanity_workload_name" {
  type    = string
  default = "sanity-workload"
}

variable "sanity_phase" {
  type    = string
  default = "phase1"
}

variable "catalog" {
  type    = string
  default = "default-bitnami"
}

variable "chart" {
  type    = string
  default = "wordpress"
}

variable "chart_version" {
  type    = string
  default = "19.2.1"

}

variable "revision" {
  type    = string
  default = "gitops"
}

variable "domain" {
  type    = string
  default = "hictl.dev.rafay-edge.net"
}

variable "continue" {
  type    = string
  default = "true"
}

variable "rollback" {
  type    = string
  default = "false"
}

variable "values_repo" {
  type    = string
  default = "rafay-paas-demos-manifests"
}

variable "custom_value_path" {
  default = "overrides/values.yaml"
}
