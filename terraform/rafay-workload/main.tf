resource "rafay_namespace" "namespace" {
  metadata {
    name    = var.workload_namespace
    project = var.workload_project
  }
  spec {
    drift {
      enabled = true
    }
    placement {
      labels {
        key   = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
  }
}

resource "rafay_workload" "workload" {
  depends_on = [rafay_namespace.namespace, local_file.values]
  metadata {
    name    = var.workload_name
    project = var.workload_project
  }
  spec {
    namespace = var.workload_namespace
    placement {
      selector = "rafay.dev/clusterName=${var.cluster_name}"
    }
    version = "v1"
    artifact {
      type = "Helm"
      artifact {
        chart_path {
          name = "file://django-app-0.1.0.tgz"
        }
        values_paths {
          name = "file://values.yaml"
        }
      }
#      options {
#        set_string = [
#          "server.server.env.celeryBrokerUrl=redis://${var.redis_config_endpoint}:6379/0",
#          "server.server.env.celeryResultBackend=redis://${var.redis_config_endpoint}:6379/0",
#          "server.server.env.postgresHost=${var.postgres_host}",
#          "server.server.env.postgresPassword=${var.postgres_password}",
#          "server.server.env.postgresUser=${var.postgres_username}",
#          "server.server.env.postgresPort=${var.postgres_port}",
#          "worker.worker.env.celeryBrokerUrl=redis://${var.redis_config_endpoint}:6379/0",
#          "worker.worker.env.celeryResultBackend=redis://${var.redis_config_endpoint}:6379/0",
#          "worker.worker.env.postgresHost=${var.postgres_host}",
#          "worker.worker.env.postgresPassword=${var.postgres_password}",
#          "worker.worker.env.postgresUser=${var.postgres_username}",
#          "worker.worker.env.postgresPort=${var.postgres_port}",
#        ]
#      }
    }
  }
}

resource "local_file" "values" {
  content  = <<EOT
db:
  enabled: false
  db:
    env:
      postgresDb: postgres
      postgresPassword: postgres
      postgresUser: postgres
    image:
      repository: postgres
      tag: 13.0-alpine
  ports:
    - name: "5432"
      port: 5432
      targetPort: 5432
  replicas: 1
  type: ClusterIP
kubernetesClusterDomain: cluster.local
nginx:
  nginx:
    image:
      repository: nginx
      tag: 1.23-alpine
  ports:
    - name: "80"
      port: 80
      targetPort: 80
  replicas: 1
  type: ClusterIP
nginxConfig:
  nginxConf: |-
    server {
        listen 80;
        server_name _;
        server_tokens off;
        client_max_body_size 20M;
        location / {
            try_files $uri @proxy_api;
        }
        location /admin {
            try_files $uri @proxy_api;
        }
        location @proxy_api {
            proxy_set_header Host $http_host;
            proxy_redirect off;
            proxy_pass   http://server:8000;
        }
        location /django_static/ {
            autoindex on;
            alias /app/backend/django_static/;
        }
    }
pvc:
  postgresData:
    storageRequest: 100Mi
  staticVolume:
    storageRequest: 100Mi
redis:
  enabled: false
  ports:
    - name: "6379"
      port: 6379
      targetPort: 6379
  redis:
    image:
      repository: redis
      tag: 7.0.5-alpine
  replicas: 1
  type: ClusterIP
server:
  ports:
    - name: "8000"
      port: 8000
      targetPort: 8000
  replicas: 1
  server:
    env:
      celeryBrokerUrl: 'redis://${var.redis_config_endpoint}:6379/0'
      celeryResultBackend: 'redis://${var.redis_config_endpoint}:6379/0'
      debug: "True"
      djangoDb: postgresql
      postgresHost: '${var.postgres_host}'
      postgresName: postgres
      postgresPassword: '${var.postgres_password}'
      postgresPort: '${var.postgres_port}'
      postgresUser: '${var.postgres_username}'
    image:
      repository: eaasunittest/django-server
      tag: latest
  type: ClusterIP
worker:
  replicas: 1
  worker:
    env:
      celeryBrokerUrl: 'redis://${var.redis_config_endpoint}:6379/0'
      celeryResultBackend: 'redis://${var.redis_config_endpoint}:6379/0'
      debug: "True"
      djangoDb: postgresql
      postgresHost: '${var.postgres_host}'
      postgresName: postgres
      postgresPassword: '${var.postgres_password}'
      postgresPort: '${var.postgres_port}'
      postgresUser: '${var.postgres_username}'
    image:
      repository: eaasunittest/django-worker
      tag: latest
networkPolicy:
  enabled: false
EOT
  filename = "values.yaml"
}