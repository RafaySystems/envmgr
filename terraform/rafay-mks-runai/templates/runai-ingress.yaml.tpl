apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: runai-cluster-ingress
  namespace: ${namespace}
  annotations:
    cert-manager.io/cluster-issuer: "${cluster_issuer_name}"

    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"

    nginx.ingress.kubernetes.io/proxy-connect-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"

    nginx.ingress.kubernetes.io/websocket-services: "researcher-service"
spec:
  ingressClassName: nginx

  tls:
  - hosts:
    - ${cluster_fqdn}
    secretName: ${tls_secret_name}

  rules:
  - host: ${cluster_fqdn}
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            # researcher-service is the main user-facing service created by Run:AI Helm chart
            name: researcher-service
            port:
              number: 4180
