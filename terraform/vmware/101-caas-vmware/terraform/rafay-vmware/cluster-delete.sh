#!/bin/bash
set -x

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

# Run the delete command
delete_output=$(./rctl delete cluster $CLUSTER_NAME -p $PROJECT_NAME -y || true)

# Check if the delete command ran successfully
if [ $? -eq 0 ]; then
    echo "Delete command ran successfully."

    # Infinite loop to check the status
    while true; do
        # Run the get command and parse the output
        response=$(./rctl get cluster $CLUSTER_NAME -p $PROJECT_NAME -o json 2>&1)

        if [[ "$response" == *Error:* ]]; then
            echo "Cluster Deletion Done"
            exit 0
        fi

        # Parse the status
        status=$(echo "$response" | ./jq -r '.status.conditions[] | select(.type == "ClusterDeleted") | .status')

        # Check if the status is "Success"
        if [ "$status" == "Success" ]; then
            echo "Deleted successfully."
            exit 0
        fi
    done
else
    echo "Error: Delete command failed."
    exit 1
fi
