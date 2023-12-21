output "frontend-app-url" {
    value = "http://${data.kubernetes_service.frontend_app_svc.status.0.load_balancer.0.ingress[0].hostname}"
}