data "rafay_download_kubeconfig" "cluster" {
  cluster = var.cluster_name
}

resource "null_resource" "setup" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./scripts/setup.sh; ./scripts/setup.sh"
    working_dir = path.module
  }

  triggers = {
    always_run = timestamp()
  }
}

locals {
  has_nodes = length(var.nodes_information.nodes_info) > 0

  first_node_key = local.has_nodes ? keys(var.nodes_information.nodes_info)[0] : ""
  first_node     = local.has_nodes ? var.nodes_information.nodes_info[local.first_node_key] : null

  dns_safe_cluster_name = lower(replace(var.cluster_name, "_", "-"))

  cluster_fqdn = local.has_nodes ? "${local.dns_safe_cluster_name}.${var.dns_domain}" : ""

  tls_secret_name = "runai-tls-${var.cluster_name}"

  public_ip = local.has_nodes ? local.first_node.ip_address : ""

  kubeconfig_parsed = yamldecode(data.rafay_download_kubeconfig.cluster.kubeconfig)

  host = local.kubeconfig_parsed.clusters[0].cluster.server

  certificate_authority_data = local.kubeconfig_parsed.clusters[0].cluster["certificate-authority-data"]

  client_certificate_data = local.kubeconfig_parsed.users[0].user["client-certificate-data"]

  client_key_data = local.kubeconfig_parsed.users[0].user["client-key-data"]

  kubeconfig_content = data.rafay_download_kubeconfig.cluster.kubeconfig
}

resource "aws_route53_record" "runai_cluster" {
  zone_id         = var.route53_zone_id
  name            = local.cluster_fqdn
  type            = "A"
  ttl             = 300
  records         = [local.public_ip]
  allow_overwrite = true

  lifecycle {
    precondition {
      condition     = local.has_nodes
      error_message = "Cannot create Run:AI infrastructure: No nodes available from upstream cluster. Upstream cluster provisioning failed or is incomplete."
    }
  }
}

resource "time_sleep" "wait_for_dns" {
  depends_on      = [aws_route53_record.runai_cluster]
  create_duration = "60s"
}

resource "local_sensitive_file" "kubeconfig" {
  content  = local.kubeconfig_content
  filename = "/tmp/kubeconfig-${var.cluster_name}"
}

resource "local_file" "cluster_issuer_yaml" {
  content = templatefile("${path.module}/templates/cluster-issuer.yaml.tpl", {
    cluster_issuer_name = var.cluster_issuer_name
    letsencrypt_email   = var.letsencrypt_email
  })
  filename        = "cluster-issuer.yaml"
  file_permission = "0644"
}

resource "local_file" "runai_ingress_yaml" {
  content = templatefile("${path.module}/templates/runai-ingress.yaml.tpl", {
    cluster_fqdn        = local.cluster_fqdn
    tls_secret_name     = local.tls_secret_name
    cluster_issuer_name = var.cluster_issuer_name
    namespace           = var.namespace
  })
  filename        = "runai-ingress.yaml"
  file_permission = "0644"

  lifecycle {
    create_before_destroy = false
  }
}

resource "null_resource" "deploy_cluster_issuer" {
  depends_on = [
    null_resource.setup,
    local_file.cluster_issuer_yaml,
    local_sensitive_file.kubeconfig
  ]

  provisioner "local-exec" {
    command     = "./kubectl --kubeconfig ${local_sensitive_file.kubeconfig.filename} apply -f cluster-issuer.yaml"
    working_dir = path.module
  }

  triggers = {
    yaml_sha = sha256(local_file.cluster_issuer_yaml.content)
  }
}

resource "null_resource" "wait_for_issuer_ready" {
  depends_on = [
    null_resource.deploy_cluster_issuer
  ]

  provisioner "local-exec" {
    command     = "./kubectl --kubeconfig ${local_sensitive_file.kubeconfig.filename} wait --for=condition=Ready clusterissuer/${var.cluster_issuer_name} --timeout=120s"
    working_dir = path.module
  }

  triggers = {
    yaml_sha = sha256(local_file.cluster_issuer_yaml.content)
  }
}

resource "null_resource" "create_runai_cluster" {
  depends_on = [
    null_resource.setup,
    time_sleep.wait_for_dns
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./scripts/create-runai-cluster.sh; CLUSTER_NAME='${var.cluster_name}' CLUSTER_FQDN='${local.cluster_fqdn}' ./scripts/create-runai-cluster.sh"
    working_dir = path.module
  }

  triggers = {
    always_run     = timestamp()
    cluster_name   = var.cluster_name
    cluster_fqdn   = local.cluster_fqdn
    chart_version  = var.runai_chart_version
    helm_namespace = var.namespace
  }
}

data "local_file" "runai_control_plane_url" {
  depends_on = [null_resource.create_runai_cluster]
  filename   = "${path.module}/control_plane_url.txt"
}

data "local_file" "runai_cluster_uuid" {
  depends_on = [null_resource.create_runai_cluster]
  filename   = "${path.module}/cluster_uuid.txt"
}

data "local_sensitive_file" "runai_client_secret" {
  depends_on = [null_resource.create_runai_cluster]
  filename   = "${path.module}/client_secret.txt"
}

resource "helm_release" "runai_cluster" {
  depends_on = [
    null_resource.wait_for_issuer_ready,
    null_resource.create_runai_cluster
  ]

  name       = "runai-cluster"
  repository = var.runai_helm_repo
  chart      = "runai-cluster"
  version    = var.runai_chart_version
  namespace  = var.namespace

  create_namespace = true
  wait             = true
  timeout          = 600
  verify           = false

  set = [
    {
      name  = "runai-operator.researcherService.ingress.enabled"
      value = "false"
    },
    {
      name  = "runai-operator.clusterApi.ingress.enabled"
      value = "false"
    },
    {
      name  = "controlPlane.url"
      value = "https://${data.local_file.runai_control_plane_url.content}"
    },
    {
      name  = "cluster.uid"
      value = data.local_file.runai_cluster_uuid.content
    },
    {
      name  = "cluster.url"
      value = "https://${local.cluster_fqdn}"
    }
  ]

  set_sensitive = [
    {
      name  = "controlPlane.clientSecret"
      value = data.local_sensitive_file.runai_client_secret.content
    }
  ]

  lifecycle {
    ignore_changes = [
      metadata[0].revision,
      metadata[0].values,
      metadata[0].last_deployed
    ]
  }
}

resource "null_resource" "create_runai_cluster_admin" {
  depends_on = [
    null_resource.setup,
    null_resource.create_runai_cluster,
    helm_release.runai_cluster,
    null_resource.deploy_runai_ingress
  ]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "chmod +x ./scripts/create-runai-cluster-admin.sh; CLUSTER_UUID='${data.local_file.runai_cluster_uuid.content}' USER_EMAIL='${var.user_email}' ./scripts/create-runai-cluster-admin.sh"
    working_dir = path.module
  }

  triggers = {
    always_run   = timestamp()
    cluster_uuid = data.local_file.runai_cluster_uuid.content
    user_email   = var.user_email
  }
}

data "local_sensitive_file" "runai_user_password" {
  depends_on = [null_resource.create_runai_cluster_admin]
  filename   = "${path.module}/user_password.txt"
}

data "local_file" "runai_user_id" {
  depends_on = [null_resource.create_runai_cluster_admin]
  filename   = "${path.module}/user_id.txt"
}

resource "null_resource" "deploy_runai_ingress" {
  depends_on = [
    null_resource.setup,
    helm_release.runai_cluster,
    local_file.runai_ingress_yaml,
    local_sensitive_file.kubeconfig
  ]

  provisioner "local-exec" {
    command     = <<-EOT
      echo "Verifying runai-ingress.yaml exists and has content..."
      if [ ! -f runai-ingress.yaml ]; then
        echo "ERROR: runai-ingress.yaml not found!"
        exit 1
      fi
      echo "File size: $(wc -c < runai-ingress.yaml) bytes"
      echo "File content preview:"
      head -5 runai-ingress.yaml
      echo "Applying ingress..."
      ./kubectl --kubeconfig ${local_sensitive_file.kubeconfig.filename} apply -f runai-ingress.yaml
    EOT
    working_dir = path.module
  }

  triggers = {
    yaml_sha = sha256(local_file.runai_ingress_yaml.content)
  }
}

# ACTIVELY WAIT for Certificate to be issued
# NOTE: Commented out for demo purposes (NV Launchpad env port 80 is not open) - certificate will be created but we won't wait for it
# The certificate requires port 80 to be publicly accessible for Let's Encrypt HTTP-01 challenge
# For production, uncomment this resource and ensure port 80 is open
# resource "null_resource" "wait_for_certificate_ready" {
#   depends_on = [
#     null_resource.deploy_runai_ingress
#   ]
#
#   provisioner "local-exec" {
#     # This command polls for up to 5 minutes for the certificate to be issued and ready
#     # cert-manager will handle the HTTP-01 challenge and ACME communication
#     # Uses locally downloaded kubectl binary (from setup.sh).
#     command     = "./kubectl --kubeconfig ${local_sensitive_file.kubeconfig.filename} wait --for=condition=Ready certificate/${local.tls_secret_name} -n ${var.namespace} --timeout=300s"
#     working_dir = path.module
#   }
#
#   triggers = {
#     yaml_sha = sha256(local_file.runai_ingress_yaml.content)
#   }
# }

resource "null_resource" "delete_runai_cluster" {
  depends_on = [
    null_resource.create_runai_cluster,
    helm_release.runai_cluster,
    null_resource.create_runai_cluster_admin
  ]

  triggers = {
    cluster_uuid         = data.local_file.runai_cluster_uuid.content
    control_plane_url    = data.local_file.runai_control_plane_url.content
    cluster_name         = var.cluster_name
    user_email           = var.user_email
    user_id              = try(data.local_file.runai_user_id.content, "")
    working_directory    = path.module
  }

  provisioner "local-exec" {
    when        = destroy
    working_dir = self.triggers.working_directory
    interpreter = ["/bin/bash", "-c"]

    environment = {
      CLUSTER_UUID            = self.triggers.cluster_uuid
      RUNAI_CONTROL_PLANE_URL = self.triggers.control_plane_url
      CLUSTER_NAME            = self.triggers.cluster_name
      USER_EMAIL              = self.triggers.user_email
      USER_ID                 = self.triggers.user_id
    }

    command = <<-EOT
      chmod +x ./scripts/setup.sh
      ./scripts/setup.sh

      chmod +x ./scripts/delete-runai-cluster.sh

      ./scripts/delete-runai-cluster.sh
    EOT
  }
}

resource "null_resource" "audit_cluster" {
  depends_on = [
    null_resource.deploy_runai_ingress,
    helm_release.runai_cluster,
    null_resource.create_runai_cluster_admin
  ]

  provisioner "local-exec" {
    command = <<-EOT
      chmod +x ./scripts/audit-cluster.sh

      export RUNAI_CONTROL_PLANE_URL="${data.local_file.runai_control_plane_url.content}"
      export CLUSTER_UUID="${data.local_file.runai_cluster_uuid.content}"
      export KUBECONFIG="${local_sensitive_file.kubeconfig.filename}"

      echo "=========================================="
      echo "Running cluster audit..."
      echo "=========================================="

      ./kubectl --kubeconfig ${local_sensitive_file.kubeconfig.filename} version --short || echo "kubectl check failed"
      ./scripts/audit-cluster.sh > cluster-audit-report.txt 2>&1 || echo "Audit script completed with warnings"

      echo ""
      echo "=========================================="
      echo "Audit report saved to: cluster-audit-report.txt"
      echo "=========================================="

      echo ""
      echo "==================================="
      echo "Run:AI Cluster Onboarding Complete"
      echo "==================================="
      echo "Cluster FQDN: ${local.cluster_fqdn}"
      echo "Public IP: ${local.public_ip}"
      echo "DNS Record: ${aws_route53_record.runai_cluster.fqdn}"
      echo "TLS Secret: ${local.tls_secret_name} (pending certificate issuance)"
      echo ""
      echo "Access Run:AI SaaS UI to submit jobs"
      echo "Cluster ingress: https://${local.cluster_fqdn} (requires port 80 for TLS cert)"
      echo "==================================="
    EOT
    working_dir = path.module
  }

  triggers = {
    always_run = timestamp()
  }
}
