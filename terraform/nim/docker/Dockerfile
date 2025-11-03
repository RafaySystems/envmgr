FROM alpine:3.19

RUN apk add --no-cache curl bash git

# Install required packages, now includes jq
RUN apk add --no-cache curl bash git jq

# Install envsubst (part of gettext)
RUN apk add --no-cache gettext

# Install OpenSSL
RUN apk add --no-cache openssl

RUN set -e && \
    KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt | tr -d '\r\n') && \
    echo "Kubectl version: '${KUBECTL_VERSION}'" && \
    curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

RUN HELM_VERSION="v3.12.3" && \
    curl -LO https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    rm -rf linux-amd64 helm-${HELM_VERSION}-linux-amd64.tar.gz

# Copy shell script into the container
COPY run.sh /usr/local/bin/run.sh

# Make sure the script is executable
RUN chmod +x /usr/local/bin/run.sh

# Set the script to run when the container starts
CMD ["/usr/local/bin/run.sh"]