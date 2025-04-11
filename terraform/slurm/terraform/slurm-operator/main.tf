
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "crds.enabled"
    value = "true"
  }
}


resource "helm_release" "prometheus" {
  name       = "prometheus"
  namespace  = "prometheus"
  create_namespace = true

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "slurm-operator" {
  create_namespace = true
  name             = "slurm-operator"
  namespace        = "slurm-operator"
  repository       = "oci://ghcr.io/slinkyproject/charts/slurm-operator"
  chart            = "slurm-operator"
  values           = [file("${path.module}/values-operator.yaml")]
}
