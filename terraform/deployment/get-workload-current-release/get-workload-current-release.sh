#!/bin/bash

set -e

#Download jq
wget https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq > /dev/null 2>&1
chmod +x ./jq > /dev/null 2>&1

#Download Rafay CLI RCTL
RCTL_FILE="rctl-linux-amd64.tar.bz2"
RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
#RCTL_URL="https://rafay-qc-cli.s3.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
wget $RCTL_URL -O $RCTL_FILE  > /dev/null 2>&1
tar -xvf $RCTL_FILE  > /dev/null 2>&1
chmod +x ./rctl  > /dev/null 2>&1

# echo $WORKLOAD_NAME
# echo $PROJECT_NAME
# echo $NEW_RELEASE_BRANCH

WORKLOAD_NAME=$1
PROJECT_NAME=$2
NEW_RELEASE_BRANCH=$3

OUTPUT=`./rctl get workload $WORKLOAD_NAME -p $PROJECT_NAME --v3 || true`
if $OUTPUT ;
then
    RETURN=`./jq -n --arg return_value $NEW_RELEASE_BRANCH '{"rollback_branch":$return_value}'`
    echo $RETURN
else
    CURRENT_RELEASE=`./rctl get workload $WORKLOAD_NAME -p $PROJECT_NAME --v3 -o json | ./jq '.spec.artifact.artifact.valuesRef.revision' | cut -d'"' -f2`
    RETURN=`./jq -n --arg return_value $CURRENT_RELEASE '{"rollback_branch":$return_value}'`
    echo $RETURN
fi
