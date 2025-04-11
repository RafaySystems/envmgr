#!/bin/bash

set -ex

# Sleep to make sure server is up.
#sleep 300

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
#RCTL_URL="https://s3.amazonaws.com/rafay-cli/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL -O $RCTL_FILE
if [ $? -eq 0 ];
then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE
./rctl config init $rctlconfig
#Check rctl version
./rctl version

sleep 10
EDGE_ID=`./rctl get cluster $cluster_name -o yaml | grep edgeid: | head -1 | sed -n -e 's/^.*edgeid: //p'`
echo "edge ID: $EDGE_ID"
echo $EDGE_ID >> edgeid.txt
