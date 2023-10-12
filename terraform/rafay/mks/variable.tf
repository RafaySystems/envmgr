variable "cluster_name" {
  type = string
}

variable "private_ip" {
  type = list(string)
}

variable "public_ip" {
  type = list(string)
}

variable "hostname" {
  type = list(string)
}

variable "server_count" {
  type = number
}

variable "project_name" {
  type = string
}

variable "rafay_location" {
  type = string
}

variable "location_mapping" {
  description = "mapping for location for Rafay - PhoenixNAP"
  default = {
    "PHX" = "dallas-us",
    "ASH" = "arlington-us",
    "SGP" = "singapore-sg",
    "NLD" = "amsterdam-nl",
    "CHI" = "chicago-us",
    "SEA" = "seattle-us",
    "AUS" = "dallas-us"
  }
}
