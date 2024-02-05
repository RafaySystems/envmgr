variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}


variable "repository" {
  type = object({
    endpoint = string
    type     = string
  })
}

variable "iprange" {
  type = string
}