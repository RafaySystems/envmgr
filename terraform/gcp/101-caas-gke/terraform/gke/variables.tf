variable "project_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "blueprint" {
  type    = string
  default = "default-gke"
}

variable "blueprint_version" {
  type    = string
  default = "latest"
}

variable "credentials_name" {
  type    = string
  default = "gke-credentials"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "network" {
  type    = string
  default = "default"
}

variable "subnet" {
  type    = string
  default = "default"
}

variable "k8s_version" {
  type    = string
  default = "1.26"
}

variable "gcp_project" {
  type = string
}

variable "node_pools" {
  type = map(object({
    name         = string
    node_size    = number
    max_nodes    = number
    min_nodes    = number
    node_version = string
    machine_type = string

  }))
  default = {
    "pool1" = {
      name         = "pool1"
      node_size    = 1
      min_nodes    = 1
      max_nodes    = 3
      node_version = "1.26"
      machine_type = "e2-standard-4"
    }
  }
}

variable "control_plane_ip_range" {
  type    = string
  default = "172.16.0.0/16"
}
