variable "enable_deep_seek_gpu" {
  description = "Enable DeepSeek using GPUs"
  type        = bool
  default     = false
}

variable "enable_deep_seek_neuron" {
  description = "Enable DeepSeek using Neuron"
  type        = bool
  default     = false
}

variable "enable_auto_mode_node_pool" {
  description = "Enable EKS AutoMode NodePool"
  type        = bool
  default     = false
}