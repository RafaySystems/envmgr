variable "project" {
  type = string
}

variable "opa_excluded_namespaces" {
  type = list(string)
  default = ["default", "kube-node-lease", "kube-public"]
}