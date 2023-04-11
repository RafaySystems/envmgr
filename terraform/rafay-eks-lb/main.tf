data "kubernetes_service_v1" "ingress-svc" {
  metadata {
    name = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
  depends_on = [rafay_download_kubeconfig.tfkubeconfig]
}

resource "rafay_download_kubeconfig" "tfkubeconfig" {
  cluster            = var.eks_cluster_name
  output_folder_path = "."
  filename           = "kubeconfig.yaml"
}

data "aws_route53_zone" "selected" {
  name         = var.dns_zone
  private_zone = false
}

resource "aws_route53_record" "app-dns" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.dns_name
  type    = "CNAME"
  ttl     = "300"
  records = [data.kubernetes_service_v1.ingress-svc.status.0.load_balancer.0.ingress.0.hostname]
}