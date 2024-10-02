variable "project" {
  type    = string
  default = "fleet"
}

variable "sanity_project" {
  type    = string
  default = "fleet"
}

variable "workload_name" {
  type    = string
  default = "sanity-workload"
}

variable "sanity_workload_name" {
  type    = string
  default = "sanity-workload"
}

variable "revision" {
  type    = string
  default = "gitops"
}
