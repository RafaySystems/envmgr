#!/bin/bash
set -e

echo "=== Setting up required tools ==="

if [ ! -f "./jq" ]; then
  echo "[+] Downloading jq binary..."
  wget -q https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux64 -O jq
  if [ $? -eq 0 ]; then
    echo "[+] Successfully downloaded jq binary"
    chmod +x ./jq
  else
    echo "[-] Failed to download jq"
    exit 1
  fi
else
  echo "[+] jq already exists, skipping download"
fi

if [ ! -f "./kubectl" ]; then
  echo "[+] Downloading kubectl binary..."
  wget -q "https://dl.k8s.io/release/$(wget -qO- https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -O kubectl
  if [ $? -eq 0 ]; then
    echo "[+] Successfully downloaded kubectl binary"
    chmod +x ./kubectl
  else
    echo "[-] Failed to download kubectl"
    exit 1
  fi
else
  echo "[+] kubectl already exists, skipping download"
fi

if [ ! -f "./curl" ]; then
  echo "[+] Downloading curl binary..."
  CURL_VERSION="8.17.0"
  CURL_URL="https://github.com/moparisthebest/static-curl/releases/download/v${CURL_VERSION}/curl-amd64"
  CHECKSUM_URL="https://github.com/moparisthebest/static-curl/releases/download/v${CURL_VERSION}/sha256sum.txt"

  echo "[+] Downloading curl v${CURL_VERSION}..."
  wget -q "$CURL_URL" -O curl.tmp
  wget -q "$CHECKSUM_URL" -O sha256sum.txt

  if [ $? -eq 0 ] && [ -f "sha256sum.txt" ]; then
    echo "[+] Verifying curl binary integrity..."
    EXPECTED_HASH=$(grep "curl-amd64" sha256sum.txt | cut -d' ' -f1)
    ACTUAL_HASH=$(sha256sum curl.tmp | cut -d' ' -f1 2>/dev/null || shasum -a 256 curl.tmp | cut -d' ' -f1)

    if [ "$EXPECTED_HASH" = "$ACTUAL_HASH" ]; then
      echo "[+] Checksum verified successfully"
      mv curl.tmp curl
      chmod +x ./curl
      rm sha256sum.txt
    else
      echo "[-] Checksum verification failed - removing invalid file"
      echo "[-] Expected: $EXPECTED_HASH"
      echo "[-] Actual:   $ACTUAL_HASH"
      rm -f curl.tmp sha256sum.txt
      exit 1
    fi
  else
    echo "[-] Failed to download curl or checksum"
    rm -f curl.tmp sha256sum.txt
    exit 1
  fi
else
  echo "[+] curl already exists, skipping download"
fi

echo "[+] Setup complete"
