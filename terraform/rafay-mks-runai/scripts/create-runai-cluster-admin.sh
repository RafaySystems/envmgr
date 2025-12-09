#!/bin/bash

set -e

GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
NC='\033[0m'

printf "${GREEN}=== Run:AI Cluster Administrator Creation ===${NC}\n"

printf "${YELLOW}DEBUG: Environment check...${NC}\n"
printf "  RUNAI_CONTROL_PLANE_URL: ${RUNAI_CONTROL_PLANE_URL:-NOT SET}\n"
printf "  RUNAI_APP_ID: ${RUNAI_APP_ID:-NOT SET}\n"
printf "  RUNAI_APP_SECRET: ${RUNAI_APP_SECRET:+SET (hidden)}\n"
printf "  CLUSTER_UUID: ${CLUSTER_UUID:-NOT SET}\n"
printf "  USER_EMAIL: ${USER_EMAIL:-NOT SET}\n\n"

if [ -z "${RUNAI_CONTROL_PLANE_URL}" ]; then
  printf "${RED}ERROR: RUNAI_CONTROL_PLANE_URL not set${NC}\n"
  exit 1
fi

if [ -z "${RUNAI_APP_ID}" ]; then
  printf "${RED}ERROR: RUNAI_APP_ID not set${NC}\n"
  exit 1
fi

if [ -z "${RUNAI_APP_SECRET}" ]; then
  printf "${RED}ERROR: RUNAI_APP_SECRET not set${NC}\n"
  exit 1
fi

if [ -z "${CLUSTER_UUID}" ]; then
  printf "${RED}ERROR: CLUSTER_UUID not set${NC}\n"
  exit 1
fi

if [ -z "${USER_EMAIL}" ]; then
  printf "${RED}ERROR: USER_EMAIL not set${NC}\n"
  exit 1
fi

USER_ROLE="System administrator"

JQ="./jq"
if [ ! -f "${JQ}" ]; then
  printf "${RED}ERROR: jq binary not found at ${JQ}${NC}\n"
  printf "${RED}Run setup.sh first to download required tools${NC}\n"
  exit 1
fi

printf "${GREEN}Configuration:${NC}\n"
printf "  Control Plane: ${RUNAI_CONTROL_PLANE_URL}\n"
printf "  Cluster UUID: ${CLUSTER_UUID}\n"
printf "  User Email: ${USER_EMAIL}\n"
printf "  User Role: ${USER_ROLE} (cluster-scoped)\n\n"

printf "${GREEN}Step 1: Authenticating with Run:AI Control Plane...${NC}\n"

TOKEN=$(wget -q -O- \
  --header="Accept: application/json" \
  --header="Content-Type: application/json" \
  --post-data="{\"grantType\":\"client_credentials\",\"clientId\":\"${RUNAI_APP_ID}\",\"clientSecret\":\"${RUNAI_APP_SECRET}\"}" \
  "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/token" | ${JQ} -r '.accessToken')

if [ -z "${TOKEN}" ] || [ "${TOKEN}" == "null" ]; then
  printf "${RED}ERROR: Failed to authenticate with Run:AI Control Plane${NC}\n"
  exit 1
fi

printf "${GREEN}✓ Authentication successful${NC}\n\n"

printf "${GREEN}Step 2: Creating user '${USER_EMAIL}'...${NC}\n"

# Check if user already exists
EXISTING_USER_RESPONSE=$(wget -q -O- \
  --header="Accept: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users")

printf "${YELLOW}DEBUG: Users list response (first 500 chars):${NC}\n${EXISTING_USER_RESPONSE:0:500}\n\n"

EXISTING_USER_ID=$(echo "${EXISTING_USER_RESPONSE}" | ${JQ} -r ".[] | select(.username==\"${USER_EMAIL}\") | .id")

if [ -n "${EXISTING_USER_ID}" ] && [ "${EXISTING_USER_ID}" != "null" ]; then
  printf "${YELLOW}User already exists with ID: ${EXISTING_USER_ID}${NC}\n"

  if [ "${FORCE_USER_RECREATE}" == "true" ]; then
    printf "${YELLOW}FORCE_USER_RECREATE=true: Deleting existing user to get fresh password...${NC}\n"

    set +e
    DELETE_RESPONSE=$(wget -S -q -O- \
      --header="Accept: application/json" \
      --header="Authorization: Bearer ${TOKEN}" \
      --header="X-HTTP-Method-Override: DELETE" \
      --post-data="" \
      "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users/${EXISTING_USER_ID}" 2>&1)
    DELETE_EXIT_CODE=$?
    set -e

    printf "${YELLOW}DEBUG: Delete response (exit code: ${DELETE_EXIT_CODE}):${NC}\n${DELETE_RESPONSE}\n\n"

    if [ ${DELETE_EXIT_CODE} -eq 0 ]; then
      printf "${GREEN}✓ Existing user deleted successfully${NC}\n"
      printf "${YELLOW}Waiting 3 seconds for deletion to complete...${NC}\n"
      sleep 3

      EXISTING_USER_ID=""
    else
      printf "${YELLOW}Warning: Failed to delete user via API.${NC}\n"
      printf "${YELLOW}User deletion might not be supported or requires different method.${NC}\n"
      printf "${YELLOW}Keeping existing user. Password will be empty.${NC}\n"
      USER_ID="${EXISTING_USER_ID}"
      echo -n "" > user_password.txt
    fi
  else
    printf "${YELLOW}Note: Cannot reset password via API (endpoint not available).${NC}\n"
    printf "${YELLOW}Using existing user. Password must be reset manually in Run:AI UI.${NC}\n"
    printf "${YELLOW}Tip: Set force_user_recreate=true in Terraform to delete and recreate user with fresh password.${NC}\n"
    USER_ID="${EXISTING_USER_ID}"

    echo -n "" > user_password.txt
  fi
fi

# Create user if doesn't exist (or was just deleted)
if [ -z "${EXISTING_USER_ID}" ] || [ "${EXISTING_USER_ID}" == "null" ]; then
  USER_RESPONSE=$(wget -S -q -O- \
    --header="Accept: application/json" \
    --header="Content-Type: application/json" \
    --header="Authorization: Bearer ${TOKEN}" \
    --post-data="{\"email\":\"${USER_EMAIL}\",\"resetPassword\":false}" \
    "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users" 2>&1)

  printf "${YELLOW}DEBUG: User creation response:${NC}\n${USER_RESPONSE}\n\n"

  if echo "${USER_RESPONSE}" | grep -q "409 Conflict"; then
    printf "${YELLOW}User already exists (409 Conflict). Fetching user ID...${NC}\n"
    EXISTING_USER_RESPONSE=$(wget -q -O- \
      --header="Accept: application/json" \
      --header="Authorization: Bearer ${TOKEN}" \
      "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users")
    USER_ID=$(echo "${EXISTING_USER_RESPONSE}" | ${JQ} -r ".[] | select(.username==\"${USER_EMAIL}\") | .id")
    printf "${GREEN}✓ Found existing user with ID: ${USER_ID}${NC}\n"

    printf "${YELLOW}Resetting password for existing user...${NC}\n"
    printf "${YELLOW}DEBUG: Calling password reset endpoint: https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users/${USER_ID}/reset-password${NC}\n"

    set +e
    RESET_RESPONSE=$(wget -S -q -O- \
      --header="Accept: application/json" \
      --header="Content-Type: application/json" \
      --header="Authorization: Bearer ${TOKEN}" \
      --post-data="" \
      "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/users/${USER_ID}/reset-password" 2>&1)
    RESET_EXIT_CODE=$?
    set -e

    printf "${YELLOW}DEBUG: Password reset response (exit code: ${RESET_EXIT_CODE}):${NC}\n${RESET_RESPONSE}\n\n"

    if [ ${RESET_EXIT_CODE} -eq 0 ]; then
      RESET_PASSWORD=$(echo "${RESET_RESPONSE}" | sed -n '/^$/,${/^$/d;p}' | ${JQ} -r '.tempPassword // empty')
      if [ -n "${RESET_PASSWORD}" ]; then
        echo -n "${RESET_PASSWORD}" > user_password.txt
        printf "${GREEN}✓ Password reset successful (will be available in Terraform outputs)${NC}\n"
      else
        echo -n "" > user_password.txt
        printf "${YELLOW}Warning: Password reset returned no password. Response: ${RESET_RESPONSE}${NC}\n"
      fi
    else
      echo -n "" > user_password.txt
      printf "${YELLOW}Warning: Password reset API failed (404 Not Found).${NC}\n"
      printf "${YELLOW}The user already exists. Use Run:AI UI to reset password if needed.${NC}\n"
      printf "${YELLOW}Login at: https://${RUNAI_CONTROL_PLANE_URL}${NC}\n"
    fi
  else
    USER_JSON=$(echo "${USER_RESPONSE}" | grep -E '^\{.*\}$' | tail -1)

    if [ -z "${USER_JSON}" ]; then
      USER_JSON=$(echo "${USER_RESPONSE}" | sed -n '/^$/,${/^$/d;p}')
    fi

    USER_ID=$(echo "${USER_JSON}" | ${JQ} -r '.id')
    GENERATED_PASSWORD=$(echo "${USER_JSON}" | ${JQ} -r '.tempPassword // empty')

    if [ -z "${USER_ID}" ] || [ "${USER_ID}" == "null" ]; then
      printf "${RED}ERROR: Failed to create user${NC}\n"
      printf "${RED}Response: ${USER_RESPONSE}${NC}\n"
      printf "${YELLOW}DEBUG: Extracted JSON: ${USER_JSON}${NC}\n"
      exit 1
    fi

    printf "${GREEN}✓ User created with ID: ${USER_ID}${NC}\n"

    if [ -n "${GENERATED_PASSWORD}" ]; then
      echo -n "${GENERATED_PASSWORD}" > user_password.txt
      printf "${GREEN}✓ Temporary password generated (will be available in Terraform outputs)${NC}\n"
    fi
  fi
fi

printf "\n"

printf "${GREEN}Step 3: Finding role '${USER_ROLE}'...${NC}\n"

ROLE_ID=$(wget -q -O- \
  --header="Accept: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/authorization/roles" | \
  ${JQ} -r ".[] | select(.name==\"${USER_ROLE}\") | .id")

if [ -z "${ROLE_ID}" ] || [ "${ROLE_ID}" == "null" ]; then
  printf "${RED}ERROR: Role '${USER_ROLE}' not found${NC}\n"
  printf "${RED}Available roles:${NC}\n"
  wget -q -O- \
    --header="Accept: application/json" \
    --header="Authorization: Bearer ${TOKEN}" \
    "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/authorization/roles" | \
    ${JQ} -r '.[].name'
  exit 1
fi

printf "${GREEN}✓ Found role with ID: ${ROLE_ID}${NC}\n\n"

printf "${GREEN}Step 4: Creating access rule (user -> cluster admin)...${NC}\n"

ACCESS_RULE_RESPONSE=$(wget -q -O- \
  --header="Accept: application/json" \
  --header="Content-Type: application/json" \
  --header="Authorization: Bearer ${TOKEN}" \
  --post-data="{\"subjectId\":\"${USER_EMAIL}\",\"subjectType\":\"user\",\"roleId\":${ROLE_ID},\"scopeId\":\"${CLUSTER_UUID}\",\"scopeType\":\"cluster\",\"clusterId\":\"${CLUSTER_UUID}\"}" \
  "https://${RUNAI_CONTROL_PLANE_URL}/api/v1/authorization/access-rules")

printf "${YELLOW}DEBUG: Access rule creation response:${NC}\n${ACCESS_RULE_RESPONSE}\n\n"

ACCESS_RULE_ID=$(echo "${ACCESS_RULE_RESPONSE}" | ${JQ} -r '.id // empty')

if [ -n "${ACCESS_RULE_ID}" ] && [ "${ACCESS_RULE_ID}" != "null" ]; then
  printf "${GREEN}✓ Access rule created with ID: ${ACCESS_RULE_ID}${NC}\n"
else
  printf "${YELLOW}Warning: Access rule may already exist or creation failed${NC}\n"
  printf "${YELLOW}Response: ${ACCESS_RULE_RESPONSE}${NC}\n"
fi

echo -n "${USER_ID}" > user_id.txt

printf "\n${GREEN}=== Summary ===${NC}\n"
printf "User Email: ${USER_EMAIL}\n"
printf "User ID: ${USER_ID}\n"
printf "User Password: ********** (available in Terraform outputs - marked as sensitive)\n"
printf "User Role: ${USER_ROLE}\n"
printf "Access Scope: Cluster-scoped (can manage this cluster only, cannot see other clusters)\n"
printf "Control Plane URL: https://${RUNAI_CONTROL_PLANE_URL}\n"
printf "${GREEN}================================${NC}\n"

exit 0
