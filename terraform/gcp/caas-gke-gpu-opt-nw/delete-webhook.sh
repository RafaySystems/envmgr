#!/usr/bin/env bash
export RCTL_PROJECT=${PROJECT}
export RCTL_API_KEY=${RAFAY_API_KEY}
export RCTL_REST_ENDPOINT=${RAFAY_REST_ENDPOINT}

wget https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2
tar -xf rctl-linux-amd64.tar.bz2
./rctl download kubeconfig --cluster ${CLUSTER_NAME} -p ${PROJECT} > ztka-user-kubeconfig
export KUBECONFIG=ztka-user-kubeconfig
wget https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl
chmod +x kubectl
./kubectl delete validatingwebhookconfiguration rafay-drift-validate-v3