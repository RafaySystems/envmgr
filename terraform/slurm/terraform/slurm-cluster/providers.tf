provider "helm" {
  kubernetes {
    config_path = "kubeconfig.json"
  }
}
