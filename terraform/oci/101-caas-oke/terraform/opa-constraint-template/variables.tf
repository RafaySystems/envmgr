variable "project" {
  type = string
}

variable "constraint_templates" {
  type = list(string)
  default = ["allowed-users-custom",
  "app-armor-custom",
  "forbidden-sysctls-custom",
  "host-filesystem-custom",
  "host-namespace-custom",
  "host-network-ports-custom",
  "linux-capabilities-custom",
  "privileged-container-custom",
  "proc-mount-custom",
  "read-only-root-filesystem-custom",
  "se-linux-custom",
  "seccomp-custom",
  "volume-types-custom",
  "disallowed-tags-custom",
  "replica-limits-custom",
  "required-annotations-custom",
  "required-labels-custom",
  "required-probes-custom",
  "allowed-repos-custom",
  "block-nodeport-services-custom",
  "https-only-custom"
  #"image-digests-custom",
  #"container-limits-custom",
  #"container-resource-ratios-custom"
]
}

variable "opa-repo" {
  type = string
  default = "opa-repo"
}

variable "opa-branch" {
  type = string
  default = "master"
}
