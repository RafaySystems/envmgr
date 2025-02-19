provider "aws" {
  region = "us-west-2" # Change to your desired region
}

data "aws_ecr_repository" "neuron-ecr" {
  name = "${var.name}-neuron-base"
}

data "aws_eks_cluster" "deepseek" {
  name = var.name 
}


provider "kubernetes" {
  #host                   = module.eks.cluster_endpoint
  #cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  host                   = data.aws_eks_cluster.deepseek.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.deepseek.certificate_authority.0.data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.deepseek.name]
  }
}

provider "helm" {
  kubernetes {
    #host                   = module.eks.cluster_endpoint
    #cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
	  host                   = data.aws_eks_cluster.deepseek.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.deepseek.certificate_authority.0.data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.deepseek.name]
    }
  }
}





resource "helm_release" "deepseek_gpu" {
  count            = var.enable_deep_seek_gpu ? 1 : 0
  name             = "deepseek-gpu"
  chart            = "./vllm-chart"
  create_namespace = true
  wait             = false
  replace          = true
  namespace        = "deepseek"

  values = [
    <<-EOT
    nodeSelector:
      owner: "data-engineer"
      instanceType: "gpu"
    tolerations:
      - key: "nvidia.com/gpu"
        operator: "Exists"
        effect: "NoSchedule"
    resources:
      limits:
        cpu: "6"
        memory: 24G
        nvidia.com/gpu: "1"
      requests:
        cpu: "4"
        memory: 16G
        nvidia.com/gpu: "1"
    command: "vllm serve deepseek-ai/DeepSeek-R1-Distill-Llama-8B --max_model 2048"
    EOT
  ]
  #depends_on = [module.eks, kubernetes_manifest.gpu_nodepool]
}

resource "helm_release" "deepseek_neuron" {
  count            = var.enable_deep_seek_neuron ? 1 : 0
  name             = "deepseek-neuron"
  chart            = "./vllm-chart"
  create_namespace = true
  wait             = false
  replace          = true
  namespace        = "deepseek"

  values = [
    <<-EOT
    image:
      repository: ${data.aws_ecr_repository.neuron-ecr.repository_url}
      tag: 0.1
      pullPolicy: IfNotPresent

    nodeSelector:
      owner: "data-engineer"
      instanceType: "neuron"
    tolerations:
      - key: "aws.amazon.com/neuron"
        operator: "Exists"
        effect: "NoSchedule"

    command: "vllm serve deepseek-ai/DeepSeek-R1-Distill-Llama-8B --device neuron --tensor-parallel-size 2 --max-num-seqs 4 --block-size 8 --use-v2-block-manager --max-model-len 2048"

    env:
      - name: NEURON_RT_NUM_CORES
        value: "2"
      - name: NEURON_RT_VISIBLE_CORES
        value: "0,1"
      - name: VLLM_LOGGING_LEVEL
        value: "INFO"

    resources:
      limits:
        cpu: "30"
        memory: 64G
        aws.amazon.com/neuron: "1"
      requests:
        cpu: "30"
        memory: 64G
        aws.amazon.com/neuron: "1"

    livenessProbe:
      httpGet:
        path: /health
        port: 8000
      initialDelaySeconds: 1800
      periodSeconds: 10

    readinessProbe:
      httpGet:
        path: /health
        port: 8000
      initialDelaySeconds: 1800
      periodSeconds: 5
    EOT
  ]
  #depends_on = [module.eks, kubernetes_manifest.neuron_nodepool]
}
