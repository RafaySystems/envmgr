#!/bin/sh

if [ -z "${KIND}" ]; then
  echo "Resource type NOT specified"
  exit 1
fi

if [ -z "${NAME}" ]; then
  echo "Resource name NOT specified"
  exit 1
fi

if [ -z "${PROJECT}" ]; then
  echo "Resource project NOT specified"
  exit 1
fi

# shellcheck source=prerequisites.sh
. prerequisites.sh
download_prerequisites

# Run RCTL delete
./rctl --wait delete "${KIND}" --project "${PROJECT}" "${NAME}"
