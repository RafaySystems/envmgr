# NIM Installation Guide

## Prerequisites

Before beginning installation, ensure you have the following:

1. A **Kubernetes Cluster**
2. A **StorageClass** available on the cluster
3. An **Ingress** with TLS certificates applied for your domain  
   _(Domain will be used for Slurm monitoring)_
4. **DNS** configured with a **wildcard entry** pointing to your Kubernetes cluster public IPs
5. **NGC API Key**
6. **Model** details:
   - Name  
   - Image  
   - Tag  
   - Type

---

## Installation Steps

### 1. Install GPU Operator

```bash
helm repo add nvidia https://helm.ngc.nvidia.com/nvidia    && helm repo update

helm install --wait --generate-name    -n gpu-operator --create-namespace    nvidia/gpu-operator
```

---

### 2. Install NIM Operator

```bash
kubectl create namespace nim-operator

helm upgrade --install nim-operator nvidia/k8s-nim-operator    -n nim-operator    --version=v3.0.0
```

---

### 3. Load Workflow Handler

```bash
rctl apply -f wfh.yaml
```

---

### 4. Load Resource Template

```bash
rctl apply -f rt.yaml
```

---

### 5. Load Environment Template

1. Update the **agent name** in `et.yaml`  
2. Update the **context data** with the **Rafay API endpoint** and **API Keys**  
3. Update variable values as needed  

Then apply the template:

```bash
rctl apply -f et.yaml
```

---

## Verification

After installation, verify that all components are running:

```bash
kubectl get pods -n gpu-operator
kubectl get pods -n nim-operator
```

All pods should show a **`Running`** or **`Completed`** status.

---

## Notes

- Ensure your GPU nodes are properly labeled and schedulable.
- If you’re using custom DNS or ingress controllers, confirm that wildcard resolution and TLS termination are correctly configured.
- The NIM Operator version (`v2.0.2 and v3.0.0`) will work with this template
