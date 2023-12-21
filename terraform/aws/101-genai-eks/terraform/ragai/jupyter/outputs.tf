output "jupiter-notebook-url" {
    value = "http://${data.kubernetes_service.proxy_public_svc.status.0.load_balancer.0.ingress[0].hostname}"
}