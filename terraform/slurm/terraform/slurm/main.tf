resource "helm_release" "slurm-operator" {
  count            = var.install_slurm_operator ? 1 : 0
  create_namespace = true
  name             = "slurm-operator"
  namespace        = "slurm-operator"
  repository       = "oci://ghcr.io/slinkyproject/charts/"
  chart            = "slurm-operator"
  version          = "0.1.0"
  values           = [file("${path.module}/values-operator.yaml")]
}


resource "helm_release" "slurm-cluster" {
  depends_on       = [helm_release.slurm-operator]
  count            = var.install_slurm_cluster ? 1 : 0
  create_namespace = true
  name             = "slurm-cluster-${var.namespace}"
  namespace        = var.namespace
  repository       = "oci://ghcr.io/slinkyproject/charts/"
  chart            = "slurm"
  version          = "0.1.0"
  values           = [file("${path.module}/values-slurm.yaml")]
}