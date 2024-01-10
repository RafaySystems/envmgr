variable "project" {
  type = string
}

variable "repo_name" {
  type = string
  default = "opa-repo"
}

variable "endpoint" {
  type = string
  default = "https://github.com/RafaySystems/getstarted.git"
}

variable "type" {
  type = string
  default = "Git"
}
