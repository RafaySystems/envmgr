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
GPU_LIMIT="${GPU_LIMIT}"
CPU_LIMIT="${CPU_LIMIT}"m
MEMORY_LIMIT="${MEMORY_LIMIT}"Mi
GPU_REQUESTS="${GPU_LIMIT}"
CPU_REQUESTS="${CPU_LIMIT}"m
MEMORY_REQUESTS="${MEMORY_LIMIT}"Mi
MODEL_NAME="${MODEL_NAME:?MODEL_NAME is required}"
NODE_SELECTOR="${NODE_SELECTOR}"
DEVICE_DETAILS="${DEVICE_DETAILS}"
ENV_VARS="${ENV_VARS}"
ENABLE_CACHE="$ENABLE_CACHE:-false"
CACHE_ENGINE="$CACHE_ENGINE"
CACHE_STORAGE_CLASS_NAME="$CACHE_STORAGE_CLASS_NAME"
CACHE_STORAGE_SIZE="$CACHE_STORAGE_SIZE"
CACHE_STORAGE_ACCESS_MODE="$CACHE_STORAGE_ACCESS_MODE:-ReadWriteOnce"
SERVICE_PORT="$SERVICE_PORT:-8000"
GRPC_PORT="$GRPC_PORT"

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
export enable_cache="$ENABLE_CACHE"
export cache_engine="$CACHE_ENGINE"
export cache_storage_class_name="$CACHE_STORAGE_CLASS_NAME"
export cache_storage_size="$CACHE_STORAGE_SIZE"
export cache_storage_access_mode="$CACHE_STORAGE_ACCESS_MODE"
export service_port="$SERVICE_PORT"
export grpc_port="$GRPC_PORT"

# Convert JSON array to Bash array
IFS=$'\n' read -r -d '' -a env_var_list < <(echo "$ENV_VARS" | jq -r '.[]' && printf '\0')

# Build YAML-formatted env block with correct newlines
env_block=""
for var in "${env_var_list[@]}"; do
  key="${var%%=*}"
  val="${var#*=}"
  env_block+="  - name: ${key}\n    value: \"${val}\"\n"
done

# Export env_block
export env_block

# Build YAML-formatted service block
if [[ "$grpc_port" == "" ]]; then
  ingress_service_port="${service_port}"
  service_block=$(cat <<EOF
  service:
    type: ClusterIP
    port: ${service_port}
EOF
)
else
  ingress_service_port="${grpc_port}"
  service_block=$(cat <<EOF
  service:
    type: ClusterIP
    port: ${service_port}
    grpcPort: ${grpc_port}
EOF
)
fi

# Export env_block
export service_block
export ingress_service_port

if [[ "$enable_cache" == "true" ]]; then
  storage_block=$(cat <<EOF
  storage:
    nimCache:
      name: ${name}
EOF
)

# Create the NIMCache manifest
cat <<EOF > nimcache.yaml
apiVersion: apps.nvidia.com/v1alpha1
kind: NIMCache
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
  source:
    ngc:
      modelPuller: ${image}
      pullSecret: ${ngc_secret}
      authSecret: ${ngc_api_secret}
      model:
        engine: ${cache_engine}
        tensorParallelism: "${gpu_limit}"
  storage:
    pvc:
      create: true
      storageClass: ${cache_storage_class_name}
      size: "${cache_storage_size}"
      volumeAccessMode: "${cache_storage_access_mode}"
  resources: {}
EOF

cat nimcache.yaml

# Apply the manifest using kubectl
kubectl apply -f nimcache.yaml

else
  storage_block=$(cat <<EOF
  storage:
    pvc:
      create: true
      storageClass: ${storage_class_name}
      size: ${storage_size}
      volumeAccessMode: ReadWriteOnce
EOF
)
fi
export storage_block

# --- Node Selector block---

if [[ -n "${DEVICE_DETAILS:-}" ]]; then
  # Extract all hostnames into an array using jq
  if HOSTNAMES_JSON=$(echo "${DEVICE_DETAILS}" | jq -r '.[].hostname' 2>/dev/null); then
    readarray -t DEVICE_HOSTNAMES <<< "${HOSTNAMES_JSON}"
  else
    echo "Error: DEVICE_DETAILS is not valid JSON" >&2
    DEVICE_HOSTNAMES=()
  fi

  if (( ${#DEVICE_HOSTNAMES[@]} > 0 )); then
    NODE_SELECTOR_BLOCK=$(cat <<EOF
  nodeSelector:
    kubernetes.io/hostname: ${DEVICE_HOSTNAMES[0]}
EOF
)

  else
    echo "Warning: DEVICE_DETAILS provided, but no hostnames found." >&2
    NODE_SELECTOR_BLOCK=""
  fi

elif [[ -n "${NODE_SELECTOR:-}" ]]; then
  # Fallback: plain string NODE_SELECTOR (already key:value)
  NODE_SELECTOR_BLOCK=$(cat <<EOF
  nodeSelector:
    ${NODE_SELECTOR}
EOF
)
else
  NODE_SELECTOR_BLOCK=""
fi

export NODE_SELECTOR_BLOCK

# --- Ingress annotations block for API token protection ---

# --- Generate or use existing API token ---
API_TOKEN=$(openssl rand -hex 16)
echo "Generated new API token: ${API_TOKEN}"
export API_TOKEN

if [[ "$grpc_port" == "" ]]; then
  if [[ -n "${API_TOKEN:-}" ]]; then
    INGRESS_ANNOTATIONS_BLOCK=$(cat <<EOF
        annotations:
          nginx.ingress.kubernetes.io/rewrite-target: "/"
          nginx.ingress.kubernetes.io/configuration-snippet: |
            if (\$http_authorization != "Bearer ${API_TOKEN}") {
              return 403;
            }
EOF
)
  else
    echo "Warning: API_TOKEN not set. Ingress will not enforce auth." >&2
    INGRESS_ANNOTATIONS_BLOCK=""
  fi
else
    INGRESS_ANNOTATIONS_BLOCK=$(cat <<EOF
        annotations:
          nginx.ingress.kubernetes.io/backend-protocol: "GRPC"
EOF
)
fi

export INGRESS_ANNOTATIONS_BLOCK

cat <<EOF > manifest.yaml
apiVersion: apps.nvidia.com/v1alpha1
kind: NIMService
metadata:
  name: ${name}
  namespace: ${namespace}
spec:
$NODE_SELECTOR_BLOCK
  image:
    repository: ${image}
    tag: ${image_tag}
    pullPolicy: IfNotPresent
    pullSecrets:
      - ${ngc_secret}
  authSecret: ${ngc_api_secret}
  replicas: 1
$storage_block
  resources:
    limits:
      nvidia.com/gpu: ${gpu_limit}
      cpu: ${cpu_limit}
      memory: ${memory_limit}
    requests:
      nvidia.com/gpu: ${gpu_requests}
      cpu: ${cpu_requests}
      memory: ${memory_requests}
  env:
$(echo -e "$env_block")
  expose:
$service_block
    ingress:
      enabled: true
$INGRESS_ANNOTATIONS_BLOCK
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
                      number: $ingress_service_port
                path: /
                pathType: Prefix
        tls:
        - hosts:
          - ${ingress_host}
EOF

cat manifest.yaml
kubectl apply -f manifest.yaml

# -------- Wait for Nim Service to be Ready --------
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=Ready --timeout=3600s nimservice/"$NAME" -n "$NAMESPACE"


# Conditional logic based on the IMAGE_TYPE variable output
if [ "$IMAGE_TYPE" == "generic" ]; then
  # Define the URL for the first model
  url="https://${ingress_host}/v1/chat/completions"
  api_key="$API_TOKEN"
  # Define the curl command for the generic model
	curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H \"Authorization: Bearer $API_TOKEN\" \
  -d '{\\\"model\\\": \\\"$MODEL_NAME\\\", \\\"messages\\\": [{\\\"content\\\": \\\"What should I do for a 4 day vacation at Cape Hatteras National Seashore?\\\", \\\"role\\\": \\\"user\\\"}], \\\"top_p\\\": 1, \\\"n\\\": 1, \\\"max_tokens\\\": 1024, \\\"stream\\\": false, \\\"frequency_penalty\\\": 0.0, \\\"stop\\\": [\\\"STOP\\\"]}'"

elif [ "$IMAGE_TYPE" == "embedded" ]; then
  # Define the URL for another model
  url="https://${ingress_host}/v1/embeddings"
  api_key="$API_TOKEN"
  # Define the curl command for the embedded model
	curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H \\\"Authorization: Bearer $API_TOKEN\\\" \
  -d '{\\\"input\\\": [\\\"Test message\\\"], \\\"model\\\": \\\"$MODEL_NAME\\\", \\\"input_type\\\": \\\"query\\\"}'"

elif [ "$IMAGE_TYPE" == "image-to-text" ]; then
  # Define the URL for image-to-text model
  url="https://${ingress_host}/v1/chat/completions"
  api_key="$API_TOKEN"
  # Define the curl command for the image-to-text model
	curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H \\\"Authorization: Bearer $API_TOKEN\\\" \
  -d '{\\\"model\\\": \\\"$MODEL_NAME\\\", \\\"messages\\\": [{\\\"role\\\": \\\"user\\\",\\\"content\\\": [{\\\"type\\\": \\\"text\\\",\\\"text\\\": \\\"What is in this image?\\\"},{\\\"type\\\": \\\"image_url\\\",\\\"image_url\\\":{\\\"url\\\": \\\"https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Gfp-wisconsin-madison-the-nature-boardwalk.jpg/2560px-Gfp-wisconsin-madison-the-nature-boardwalk.jpg\\\"}}]}],\\\"max_tokens\\\": 1024}'"

elif [ "$IMAGE_TYPE" == "text-to-image" ]; then
  # Define the URL for text-to-image model
  url="https://${ingress_host}/v1/infer"
  api_key="$API_TOKEN"
  # Define the curl command for the text-to-image model
	curlcommand="curl -X \\\"POST\\\" \\\"$url\\\" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H \\\"Authorization: Bearer $API_TOKEN\\\" \
  -d '{\\\"prompt\\\": [\\\"A simple coffee shop interior\\\"], \\\"mode\\\": \\\"base\\\", \\\"seed\\\": \\\"0\\\", \\\"steps\\\": \\\"30\\\"}' \
  | jq -r '.artifacts[0].base64' | base64 --decode > image.jpg"

elif [ "$IMAGE_TYPE" == "streaming" ]; then
  # Define the URL for another model
  url="${ingress_host}"
  api_key="$API_TOKEN"
  # Define the curl command for the text-to-image model
	curlcommand="Streaming model with GRPC endpoint ${ingress_host}"

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
  "API Key": "$api_key",
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
