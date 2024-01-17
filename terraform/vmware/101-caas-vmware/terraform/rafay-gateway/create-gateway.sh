#!/bin/bash

wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq
chmod +x ./jq

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL -O $RCTL_FILE
if [ $? -eq 0 ]; then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE

# Check if the gateway already exists
existing_gateway=$(./rctl get gateway $GATEWAY_NAME -p $PROJECT_NAME -o json 2>/dev/null)

if [[ $(echo $existing_gateway | ./jq -r '.metadata.name') == "$GATEWAY_NAME" ]]; then
    echo "[+] Gateway $GATEWAY_NAME already exists. Writing to output.json."
else
    # Run the create gateway command
    ./rctl create gateway $GATEWAY_NAME --gatewaytype vmware -p $PROJECT_NAME 
    sleep 10
    echo "[+] Creating new gateway $GATEWAY_NAME."
fi

# Run the get gateway command and store the response in a variable
existing_gateway=$(./rctl get gateway $GATEWAY_NAME --configdetails -p $PROJECT_NAME  2>/dev/null)

# Extract information from the response and store in variables
bootstrapRepoUrl=$(echo $existing_gateway | ./jq -r '.bootstrapRepoUrl')
agentID=$(echo $existing_gateway | ./jq -r '.agentID')
token=$(echo $existing_gateway | ./jq -r '.relays[0].token')

echo "{\"Bootstrap_url\":\"$bootstrapRepoUrl\",\"agent_id\":\"$agentID\",\"Token\":\"$token\"}" > output.json
