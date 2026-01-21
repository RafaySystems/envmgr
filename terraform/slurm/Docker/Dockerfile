FROM alpine:3.19

# BuildKit-provided args
ARG TARGETARCH

# Install required packages
RUN apk add --no-cache \
    curl \
    bash \
    git \
    jq \
    gettext

# Install kubectl (multi-arch)
RUN set -e && \
    KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt | tr -d '\r\n') && \
    echo "Installing kubectl ${KUBECTL_VERSION} for ${TARGETARCH}" && \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install helm (multi-arch)
RUN set -e && \
    HELM_VERSION="v3.12.3" && \
    echo "Installing helm ${HELM_VERSION} for ${TARGETARCH}" && \
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" && \
    tar -zxvf "helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz" && \
    mv "linux-${TARGETARCH}/helm" /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf "linux-${TARGETARCH}" "helm-${HELM_VERSION}-linux-${TARGETARCH}.tar.gz"

# Copy shell script into the container
COPY run.sh /usr/local/bin/run.sh

# Copy Helm and config files
COPY pvc-data.yaml /helm/pvc-data.yaml
COPY pvc-users.yaml /helm/pvc-users.yaml
COPY values-slurm.yaml /helm/values-slurm.yaml
COPY prometheus-values.yaml /helm/prometheus-values.yaml
COPY grafana-values.yaml /helm/grafana-values.yaml
COPY slinky-dashboard.json /helm/slinky-dashboard.json

# Make sure the script is executable
RUN chmod +x /usr/local/bin/run.sh

# Set the script to run when the container starts
CMD ["/usr/local/bin/run.sh"]
