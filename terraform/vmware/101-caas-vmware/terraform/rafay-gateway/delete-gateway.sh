#!/bin/bash

set -ex

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL -O $RCTL_FILE
if [ $? -eq 0 ];
then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE

./rctl delete gateway $GATEWAY_NAME  -p $PROJECT_NAME -y
if [ $? -eq 0 ]; then
    echo "Successfully deleted $GATEWAY_NAME"
    exit 0
else
    echo "Failed to delete $GATEWAY_NAME"
    exit 1
fi
