output "lb-cname" {
  value = data.kubernetes_service_v1.ingress-svc.status.0.load_balancer.0.ingress.0.hostname
}
