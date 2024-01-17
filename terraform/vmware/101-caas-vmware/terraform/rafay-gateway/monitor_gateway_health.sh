#!/bin/bash

set -ex

timeout_duration=1200  # 20 minutes in seconds
start_time=$(date +%s)

# Function to check gateway health
check_health() {
    healthStatus=$(./rctl get gateway $GATEWAY_NAME --health -p $PROJECT_NAME | ./jq -r '.status')
    if [ "$healthStatus" == "HEALTHY" ]; then
        echo "[+] Gateway is healthy."
        exit 0
    else
        echo "[-] Gateway is not healthy yet. Waiting..."
        sleep 10
    fi
}

# Loop with timeout
while true; do
    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))

    if [ $elapsed_time -ge $timeout_duration ]; then
        echo "Error: Gateway cannot become healthy. Please check the gateway logs in vCenter."
        exit 1
    fi

    check_health
done
