#!/bin/bash

set -ex

cat $filename

# Download jq
wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq
chmod +x ./jq

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL -O $RCTL_FILE
if [ $? -eq 0 ]; then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE

# Cluster Provision 
./rctl apply -f $filename > cluster.log
sleep 10

cluster_name=$(./jq -r '.metadata.name' cluster.log)

echo "Cluster name: $cluster_name"

# Cluster status tracking

while true; do
    response=$(./rctl get clusters $cluster_name -p $PROJECT_NAME -o json)

    conditions=("ClusterInitialized" "ClusterBootstrapNodeInitialized" "ClusterProviderInfraInitialized" "ClusterSpecApplied" "ClusterControlPlaneReady" "ClusterCNISpecApplied" "ClusterOperatorSpecApplied" "ClusterHealthy" "ClusterPivoted" "ClusterBootstrapNodeDeleted")

    all_conditions_met=true

    for condition in "${conditions[@]}"; do
        status=$(echo "$response" | ./jq -r ".status.conditions[] | select(.type == \"$condition\") | .status")

        if [ "$status" != "Success" ]; then
            if [ "$status" == "Failed" ]; then
                echo "Condition $condition failed with status: $status"
                exit 1
            else
                all_conditions_met=false
                echo "Condition $condition has status: $status"
            fi
        fi
    done

    if $all_conditions_met; then
        echo "Cluster up and healthy"
        exit 0
    fi

    sleep 10
done
