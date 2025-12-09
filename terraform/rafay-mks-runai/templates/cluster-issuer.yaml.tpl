apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${cluster_issuer_name}
spec:
  acme:
    email: ${letsencrypt_email}

    server: https://acme-v02.api.letsencrypt.org/directory

    privateKeySecretRef:
      name: ${cluster_issuer_name}-account-key

    solvers:
    - http01:
        ingress:
          class: nginx
