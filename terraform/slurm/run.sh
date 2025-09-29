#!/bin/bash
echo "starting script..."

set -euo pipefail

# -------- Input Variables --------
PUBLIC_IP="${PUBLIC_IP}"
NAMESPACE="${NAMESPACE}"
STORAGECLASS="${STORAGE_CLASS_NAME}"
SSH_PUB_KEY="${SSH_PUB_KEY}"
COMPUTE_REPLICAS="${COMPUTE_REPLICAS}"
CPUS="${CPUS}"
MEMORY="${MEMORY}"
GPUS="${GPUS}"
COMPUTE_TAG="${COMPUTE_TAG}"
SHAREDSTORAGE_CLASS="${SHARED_STORAGE_CLASS_NAME}"
SHARED_STORAGE_SIZE="${SHARED_STORAGE_SIZE}"
INGRESS_DOMAIN="${DOMAIN:-example.com}"
CHART_VERSION="0.3.0"

INGRESS_HOST="${NAMESPACE}.${INGRESS_DOMAIN}"

NODE_SELECTOR_KEY="${NODE_SELECTOR_KEY}"
NODE_SELECTOR_VALUE="${NODE_SELECTOR_VALUE}"

if [[ -n "$NODE_SELECTOR_KEY" && -n "$NODE_SELECTOR_VALUE" ]]; then
  # Indent 6 spaces to match the nodeset level in your YAML
  NODE_SELECTOR_BLOCK="      nodeSelector:
        $NODE_SELECTOR_KEY: $NODE_SELECTOR_VALUE"
else
  NODE_SELECTOR_BLOCK=""
fi

export NODE_SELECTOR_BLOCK

# Setup kubeconfig file
export KUBECONFIG=~/kubeconfig.yaml
echo "$VAR_kubeconfig" >> ~/kubeconfig.yaml
chmod 600 "$KUBECONFIG"

if [ "${ACTION}" == "destroy" ]; then

    echo "Running destroy commands..."
	
	# Uninstall Slurm Helm chart
	helm uninstall slurm -n ${NAMESPACE}

	# Uninstall Prometheus / monitoring Helm chart
	helm uninstall slurm-monitoring-${NAMESPACE} -n ${NAMESPACE}
	
	# Delete the namespace entirely
	kubectl delete namespace ${NAMESPACE} &
	
	echo "Waiting for namespace ${NAMESPACE} to be deleted..."

	# Loop until namespace no longer exists
	while kubectl get namespace "${NAMESPACE}" > /dev/null 2>&1; do
		echo "Namespace ${NAMESPACE} still exists... waiting 5 seconds"
		sleep 5
	done
	
echo "Namespace '$NAMESPACE' has been deleted."


elif [ "${ACTION}" == "deploy" ]; then

    echo "Starting deployment..."
	
	# -----------------------------
	# Generate random NodePorts (between 30000-32767)
	# -----------------------------
	NODE_PORT=$((RANDOM % 2767 + 30000))
	echo "Slurm NodePort selected: $NODE_PORT"
		
	# -----------------------------
	# Create Namespace
	# -----------------------------
	echo "Creating Namespace..."
	kubectl create namespace ${NAMESPACE}
	
	# -----------------------------
	# Create PVC
	# -----------------------------
	echo "Creating PVC..."
	SHAREDSTORAGE_CLASS="${SHARED_STORAGE_CLASS_NAME}" envsubst < /helm/pvc.yaml > /tmp/pvc.yaml
	cat /tmp/pvc.yaml
	kubectl apply -f /tmp/pvc.yaml

	# -----------------------------
	# Install slurm Helm chart
	# -----------------------------
	echo "Installing slurm Helm chart..."

	STORAGECLASS="${STORAGECLASS}" envsubst < /helm/values-slurm.yaml > /tmp/values-slurm.yaml
	
	cat /tmp/values-slurm.yaml

	helm install slurm oci://ghcr.io/slinkyproject/charts/slurm \
	  --namespace "$NAMESPACE" \
	  --version "$CHART_VERSION" \
	  --wait \
	  --timeout 5m \
	  -f /tmp/values-slurm.yaml

	# -----------------------------
	# Get actual NodePort (if needed, confirm it)
	# -----------------------------
	echo "Getting assigned NodePort from Kubernetes..."

	ACTUAL_NODE_PORT=$(kubectl get svc slurm-login -n "$NAMESPACE" -o jsonpath='{.spec.ports[0].nodePort}')
	echo "Slurm Login NodePort: $ACTUAL_NODE_PORT"
		
	# -----------------------------
	# Install slinky dashboard configmap
	# -----------------------------
	echo "Installing Slinky Dashboard Configmap..."
	
	kubectl -n "$NAMESPACE" create configmap slurm-dashboard --from-file=/helm/slinky-dashboard.json
	
	# -----------------------------
	# Install Prometheus Helm chart
	# -----------------------------
	echo "Installing Prometheus Helm chart..."
	
	# Add the Prometheus Community Helm repo
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

	# Update all Helm repos
	helm repo update
	
	INGRESS_HOST="${NAMESPACE}.${INGRESS_DOMAIN}" envsubst < /helm/prometheus-values.yaml > /tmp/prometheus-values.yaml
	
	echo "Prometheus Values: "
	cat /tmp/prometheus-values.yaml
	  
	  helm install slurm-monitoring-${NAMESPACE} prometheus-community/kube-prometheus-stack \
	  --namespace "$NAMESPACE" \
	  --wait \
	  --timeout 5m \
	  -f /tmp/prometheus-values.yaml


	# -----------------------------
	# Output SSH and SCP instructions
	# -----------------------------

	SSH_CMD="ssh -p $ACTUAL_NODE_PORT root@$PUBLIC_IP -o TCPKeepAlive=yes -o ServerAliveInterval=30 -i <path to private key>"
	SCP_SCRIPT="scp -v -O -P $ACTUAL_NODE_PORT -i <path to private key> <path to data file> root@$PUBLIC_IP:/root"
	SCP_DATA="scp -v -O -P $ACTUAL_NODE_PORT -i <path to private key> <path to script file> root@$PUBLIC_IP:/mnt/data"
	Monitoring_URL="https://${INGRESS_HOST}/d/edrg5th9t1edcb/slinky-slurm?orgId=1&from=now-1h&to=now&timezone=browser&refresh=5s"

	echo ""
	echo "============================"
	echo "Slurm Cluster Deployed!"
	echo "============================"
	echo "SSH Access:"
	echo "$SSH_CMD"
	echo ""
	echo "SCP Script Example:"
	echo "$SCP_SCRIPT"
	echo ""
	echo "SCP Data Example:"
	echo "$SCP_DATA"
	echo ""
	echo "Monitoring URL:"
	echo "$Monitoring_URL"
	echo ""


	
	# Output file name
	output_file="output.json"

	# Create JSON content with the concatenated value
json_content=$(cat <<EOF
{
  "SSH": "$SSH_CMD",
  "SCP_DATA": "$SCP_DATA",
  "SCP_SCRIPT": "$SCP_SCRIPT",
  "MONITORING_URL": "$Monitoring_URL"
}
EOF
)

	# Write the JSON content to the file
	echo "$json_content" > "$output_file"

	# Confirm creation
	echo "JSON file '$output_file' created with content:"
	cat "$output_file"
	
	AUTH_TOKEN=$DRIVER_UPLOAD_TOKEN
	API_ENDPOINT=$DRIVER_UPLOAD_URL

	if [[ "${DRIVER_SKIP_TLS_VERIFY:-false}" == "true" ]]; then
		echo "insecure"
		curl  \
		 -X POST \
		 -k -F "content=@output.json" -H "X-Engine-Helper-Token: $AUTH_TOKEN" --max-time 60 \
		   --retry 3 --retry-all-errors $API_ENDPOINT     
	else
		curl  \
		 -X POST \
		 -F "content=@output.json" -H "X-Engine-Helper-Token: $AUTH_TOKEN" --max-time 60 \
		  --retry 3 --retry-all-errors  $API_ENDPOINT     
	fi

else
    echo "Invalid action: $action"
    echo "Usage: $0 [deploy|destroy]"
    exit 1
fi
