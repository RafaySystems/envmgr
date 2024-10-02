#!/bin/bash

set -e

cat $filename

#Download jq
wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq  > /dev/null 2>&1
chmod +x ./jq

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
#RCTL_URL="https://s3.amazonaws.com/rafay-cli/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL -O $RCTL_FILE  > /dev/null 2>&1
if [ $? -eq 0 ];
then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE  > /dev/null 2>&1
chmod +x ./rctl

#Deploy workload
./rctl apply -f $filename
sleep 30

WORKLOAD_STATUS_ITERATIONS=1
WORKLOAD_STATUS=`./rctl get workload $WORKLOAD_NAME -p $PROJECT_NAME --v3 -o json | ./jq '.status.reason' | cut -d'"' -f2`
while [ "$WORKLOAD_STATUS" != "workload is ready" ]
do
  if [ $WORKLOAD_STATUS_ITERATIONS -ge 60 ];
  then
    echo "Workload $WORKLOAD_NAME Deployment Status: $WORKLOAD_STATUS"
    break
    exit 1
  fi
  WORKLOAD_STATUS_ITERATIONS=$((WORKLOAD_STATUS_ITERATIONS+1))
  sleep 30
  WORKLOAD_STATUS=`./rctl get workload $WORKLOAD_NAME -p $PROJECT_NAME --v3 -o json | ./jq '.status.reason' | cut -d'"' -f2`
  echo "Workload $WORKLOAD_NAME Deployment Status: $WORKLOAD_STATUS"
done
