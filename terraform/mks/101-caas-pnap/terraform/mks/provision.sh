#!/bin/bash

set -ex

cat $filename
# Sleep to make sure server is up.
sleep 300
#Download jq
wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq
chmod +x ./jq

RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
#RCTL_URL="https://s3.amazonaws.com/rafay-cli/publish/rctl-linux-amd64.tar.bz2"

wget $RCTL_URL
if [ $? -eq 0 ];
then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE
#Check rctl version
./rctl apply -f $filename --dry-run
sleep 10
./rctl apply -f $filename > cluster.log
sleep 10
#cat cluster.log
ID=`cat cluster.log | grep -w taskset_id | head -n1 | awk {'print $2'} | cut -d',' -f1 | cut -d'"' -f2`
#ID=`./rctl apply -f $filename | grep -w taskset_id | head -n1 | awk {'print $2'} | cut -d',' -f1 | cut -d'"' -f2`

if [ -z "$ID" ]
then
    OPS=`cat cluster.log | ./jq '.operations == []'`
    if $OPS
    then
        cat cluster.log
        exit 0
    else
        echo "Cluster Operation Failed"
        exit 1
    fi
fi
./rctl status apply $ID
CLUSTER_STATUS_ITERATIONS=1
CLUSTER_STATUS=`./rctl status apply $ID | ./jq .status | cut -d'"' -f2`
#while [ "$CLUSTER_STATUS" != "PROVISION_TASK_STATUS_SUCCESS" ]
while [ "$CLUSTER_STATUS" != "PROVISION_TASKSET_STATUS_COMPLETE" ]
do
  sleep 60
  if [ $CLUSTER_STATUS_ITERATIONS -ge 45 ];
  then
    break
    exit 1
  fi
  CLUSTER_STATUS_ITERATIONS=$((CLUSTER_STATUS_ITERATIONS+1))
  CLUSTER_STATUS=`./rctl status apply $ID | ./jq .status | cut -d'"' -f2`
  echo "Provision Status: $CLUSTER_STATUS"
done

sleep 60
# CLUSTER_BP_ITERATIONS=1
# CLUSTER_STATUS=`./rctl status apply $ID | ./jq -r '.operations[] | select(.operation == "ClusterCreation") | .status'`
# while [ "$CLUSTER_STATUS" != "PROVISION_TASK_STATUS_SUCCESS" ]
# do
#   sleep 60
#   if [ $CLUSTER_STATUS_ITERATIONS -ge 45 ];
#   then
#     break
#     exit 1
#   fi
#   CLUSTER_STATUS_ITERATIONS=$((CLUSTER_STATUS_ITERATIONS+1))
#   CLUSTER_STATUS=`./rctl status apply $ID | ./jq -r '.operations[] | select(.operation == "ClusterCreation") | .status'`
#   echo "Provision Status: $CLUSTER_STATUS"
# done

# CLUSTER_BP_STATUS=`./rctl status apply $ID | ./jq -r '.operations[] | select(.operation == "BlueprintSync") | .status'`
# while [ "$CLUSTER_BP_STATUS" != "PROVISION_TASK_STATUS_SUCCESS" ]
# do
#   sleep 60
#   if [ $CLUSTER_BP_ITERATIONS -ge 15 ];
#   then
#     break
#     exit 1
#   fi
#   CLUSTER_BP_ITERATIONS=$((CLUSTER_BP_ITERATIONS+1))
#   CLUSTER_BP_STATUS=`./rctl status apply $ID | ./jq -r '.operations[] | select(.operation == "BlueprintSync") | .status'`
#   echo "Blueprint Status: $CLUSTER_BP_STATUS"
# done
