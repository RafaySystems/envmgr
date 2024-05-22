#!/bin/sh

set -o xtrace
set -o errexit

RCTL_URL="https://rafay-prod-cli.s3-us-west-2.amazonaws.com/publish/rctl-linux-amd64.tar.bz2"
YQ_URL="https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_linux_amd64"

cleanup_prerequisites() {
    if [ -f ./rctl ]
    then
        echo "Cleaning up rctl"
        rm ./rctl
    else
        echo "rctl does not exist"
    fi
    if [ -f ./yq ]
    then
        echo "Cleaning up yq"
        rm ./yq
    else
        echo "yq does not exist"
    fi
}

download_prerequisites() {

    trap cleanup_prerequisites EXIT

    # Download RCTL if it does not exist
    if [ ! -f ./rctl ]
    then
        echo "Downloading rctl"
        wget -qO- "${RCTL_URL}" | bzip2 -dc | tar xvf - ./rctl
        chmod +x ./rctl
        echo "Downloaded rctl"
    else
        echo "rctl already exists"
    fi

    # Download YQ if it does not exist
    if [ ! -f ./yq ]
    then
        echo "Downloading yq"
        wget -O ./yq "${YQ_URL}"
        chmod +x ./yq
        echo "Downloaded yq"
    else
        echo "yq already exists"
    fi
}
