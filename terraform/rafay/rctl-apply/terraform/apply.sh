#!/bin/sh

if [ -z "${FILE_NAME}" ]; then
  echo "File name NOT specified"
  exit 1
fi

if [ ! -f "${FILE_NAME}" ]; then
  echo "File ${FILE_NAME} does not exist"
  exit 1
fi

# shellcheck source=prerequisites.sh
. prerequisites.sh
download_prerequisites

# Convert JSON to YAML + cleanup
# Unfortunately RCTL does not support JSON files
YAML_FILE_NAME="${FILE_NAME%.json}.yaml"
./yq -P < "${FILE_NAME}" > "${YAML_FILE_NAME}"

yaml_file_cleanup() {
  # Add the pre-requisite cleanup here
  # as we'll override the EXIT trap now
  cleanup_prerequisites
  # Cleanup YAML file as well
  if [ -f "${YAML_FILE_NAME}" ]; then
    echo "Cleaning up file ${YAML_FILE_NAME}"
    rm "${YAML_FILE_NAME}"
  else
    echo "File ${YAML_FILE_NAME} does not exist"
  fi
}
trap yaml_file_cleanup EXIT

# Perform RCTL Apply
./rctl --wait apply --config-file "${YAML_FILE_NAME}"
