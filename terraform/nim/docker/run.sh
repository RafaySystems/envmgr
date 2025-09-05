#!/bin/bash
echo "starting script..."

set -euo pipefail

# -------- Input Variables --------
NAME="${NAMESPACE}"
NAMESPACE="${NAMESPACE}"
REGISTRY_SERVER="${REGISTRY_SERVER:-nvcr.io}"
REGISTRY_USERNAME="${REGISTRY_USERNAME:-\$oauthtoken}"
NGC_API_KEY="${NGC_API_KEY:?NGC_API_KEY is required}"
INGRESS_DOMAIN="${DOMAIN:-example.com}"
STORAGE_SIZE="${STORAGE_SIZE:-10Gi}"
STORAGE_CLASS_NAME="${STORAGE_CLASS_NAME:-openebs-hostpath}"
GPU_LIMIT="${GPU_LIMIT:-1}"
CPU_LIMIT="${CPU_LIMIT:-4}"
MEMORY_LIMIT="${MEMORY_LIMIT:-24Gi}"
GPU_REQUESTS="${GPU_REQUESTS:-1}"
CPU_REQUESTS="${CPU_REQUESTS:-2}"
MEMORY_REQUESTS="${MEMORY_REQUESTS:-24Gi}"
MODEL_NAME="${MODEL_NAME:?MODEL_NAME is required}"
NODE_SELECTOR="${NODE_SELECTOR:?NODE_SELECTOR is required}"

# -------- Model Info --------
# Example:
#MODEL_INFO='[{"name":"Mistral-7B-Instruct-v0.3","image":"nvcr.io/nim/mistralai/mistral-7b-instruct-v0.3","tag":"1.3.0"}]'
MODEL_INFO_STRING="${MODEL_INFO:?MODEL_INFO must be a JSON array of model info}"
MODEL_INFO=$(echo "$MODEL_INFO_STRING" | sed 's/\\"/"/g' | sed 's/^"\(.*\)"$/\1/' | jq .)


# -------- Derived Values --------
IMAGE=$(echo "$MODEL_INFO" | jq -r ".[] | select(.name==\"$MODEL_NAME\") | .image")
IMAGE_TAG=$(echo "$MODEL_INFO" | jq -r ".[] | select(.name==\"$MODEL_NAME\") | .tag")
IMAGE_TYPE=$(echo "$MODEL_INFO" | jq -r ".[] | select(.name==\"$MODEL_NAME\") | .type")

INGRESS_HOST="${NAME}.${INGRESS_DOMAIN}"

# Setup kubeconfig file
export KUBECONFIG=~/kubeconfig.yaml
echo "$VAR_kubeconfig" >> ~/kubeconfig.yaml
chmod 600 "$KUBECONFIG"

if [ "${ACTION}" == "destroy" ]; then
    echo "Running destroy commands..."
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
	
	# -------- Create Namespace --------
	echo "Creating namespace: $NAMESPACE"
	kubectl create namespace "$NAMESPACE"

	# -------- Create Docker Secret --------
	echo "Creating Docker registry secret"
	AUTH_STRING="${REGISTRY_USERNAME}:${NGC_API_KEY}"
	AUTH_BASE64=$(echo -n "$AUTH_STRING" | base64)

# Create Docker config JSON
DOCKER_CONFIG_JSON=$(jq -n \
  --arg server "$REGISTRY_SERVER" \
  --arg username "$REGISTRY_USERNAME" \
  --arg password "$NGC_API_KEY" \
  --arg auth "$(echo -n "$REGISTRY_USERNAME:$NGC_API_KEY" | base64)" \
  '{
    auths: {
      ($server): {
        username: $username,
        password: $password,
        auth: $auth
      }
    }
  }')

# Base64-encode the JSON and strip newlines
ENCODED_DOCKER_CONFIG_JSON=$(echo -n "$DOCKER_CONFIG_JSON" | base64 | tr -d '\n')

# Apply the Secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: ${NAME}-ngc-secret
  namespace: $NAMESPACE
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: $ENCODED_DOCKER_CONFIG_JSON
EOF


# -------- Create API Secret --------
echo "Creating NGC API secret"
kubectl create secret generic "${NAME}-ngc-api-secret" \
  --from-literal=NGC_API_KEY="$NGC_API_KEY" \
  --namespace "$NAMESPACE" \
  --dry-run=client -o yaml | kubectl apply -f -

# -------- Render and Apply Manifest --------
echo "Rendering and applying embedded manifest"

# Set environment variables for envsubst
export name="$NAMESPACE"
export namespace="$NAMESPACE"
export image="$IMAGE"
export image_tag="$IMAGE_TAG"
export storage_size="$STORAGE_SIZE"
export storage_class_name="$STORAGE_CLASS_NAME"
export gpu_limit="$GPU_LIMIT"
export cpu_limit="$CPU_LIMIT"
export memory_limit="$MEMORY_LIMIT"
export gpu_requests="$GPU_REQUESTS"
export cpu_requests="$CPU_REQUESTS"
export memory_requests="$MEMORY_REQUESTS"
export ngc_secret="${NAME}-ngc-secret"
export ngc_api_secret="${NAME}-ngc-api-secret"
export ingress_host="${NAMESPACE}.${DOMAIN}"
export node_selector="$NODE_SELECTOR"

envsubst <<'EOF' | kubectl apply -f -
apiVersion: apps.nvidia.com/v1alpha1
kind: NIMService
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  nodeSelector:
    nvidia.com/gpu.product: ${node_selector}
  image:
    repository: ${image}
    tag: ${image_tag}
    pullPolicy: IfNotPresent
    pullSecrets:
      - ${ngc_secret}
  authSecret: ${ngc_api_secret}
  replicas: 1
  storage:
    pvc:
      create: true
      storageClass: ${storage_class_name}
      size: ${storage_size}
      volumeAccessMode: ReadWriteOnce
  resources:
    limits:
      nvidia.com/gpu: ${gpu_limit}
      cpu: ${cpu_limit}
      memory: ${memory_limit}
    requests:
      nvidia.com/gpu: ${gpu_requests}
      cpu: ${cpu_requests}
      memory: ${memory_requests}
  expose:
    service:
      type: ClusterIP
      port: 8000
    ingress:
      enabled: true
      spec:
        ingressClassName: nginx
        rules:
          - host: ${ingress_host}
            http:
              paths:
              - backend:
                  service:
                    name: ${name}
                    port:
                      number: 8000
                path: /
                pathType: Prefix
        tls:
        - hosts:
          - ${ingress_host}
EOF

# -------- Wait for Nim Service to be Ready --------
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=Ready --timeout=3600s nimservice/"$NAME" -n "$NAMESPACE"


# Conditional logic based on the IMAGE_TYPE variable
if [ "$IMAGE_TYPE" == "generic" ]; then
    # Define the URL for the first model
    url="https://${ingress_host}/v1/chat/completions"
    
    # Define the curl command for the generic model
curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" -H 'Accept: application/json' -H 'Content-Type: application/json' -d '{\\\"model\\\": \\\"$MODEL_NAME\\\", \\\"messages\\\": [{\\\"content\\\": \\\"What should I do for a 4 day vacation at Cape Hatteras National Seashore?\\\", \\\"role\\\": \\\"user\\\"}], \\\"top_p\\\": 1, \\\"n\\\": 1, \\\"max_tokens\\\": 1024, \\\"stream\\\": false, \\\"frequency_penalty\\\": 0.0, \\\"stop\\\": [\\\"STOP\\\"]}'"


elif [ "$IMAGE_TYPE" == "embedded" ]; then
    # Define the URL for another model
    url="https://${ingress_host}/v1/embeddings"
    
    # Define the curl command for the embedded model
    curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" -H 'accept: application/json' -H 'Content-Type: application/json' -d '{\\\"input\\\": [\\\"Test message\\\"], \\\"model\\\": \\\"$MODEL_NAME\\\", \\\"input_type\\\": \\\"query\\\"}'"

else
    # Default behavior if no specific IMAGE_TYPE matches
    curlcommand="Invalid IMAGE_TYPE specified."
fi

# Output the response
echo "$curlcommand"
	
	# Output file name
	output_file="output.json"

	# Create JSON content with the concatenated value
json_content=$(cat <<EOF
{
  "URL": "$url",
  "Curl_Command": "$curlcommand"
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
