#!/bin/bash

# input from values.yaml
API_KEY=
PROJECT_NAME=""
REPO_NAME="rafay-repository"
AGENT_NAME="rafay-agent"
CLEANUP_TEMP_FILES=true
SHARING=false
# list of all templates which needs to be created
templates=(
    #"terraform/naas/101-naas"
    #"terraform/aws/101-caas-eks"
    #"terraform/aws/101-caas-ecs"
    #"terraform/aws/101-genai-ecs"
    #"terraform/aws/101-genai-eks"
    #"terraform/aws/101-kubeflow-eks"
    #"terraform/aws/101-naas-eks"
    #"terraform/aws/101-vpc-ec2"
    #"terraform/aws/101-vpc-ecs"
    #"terraform/aws/101-waas-eks"
    #"terraform/azure/101-vnet-instance"
    #"terraform/gcp/101-caas-gke"
    #"terraform/gcp/101-vpc-instance"
    #"terraform/mks/101-caas-pnap"
    #"terraform/oci/101-caas-oke"
    #"terraform/vcluster/101-caas"
    #"terraform/vmware/101-caas-vmware"
    #"terraform/waas/101-waas"
)

# console url
BASE_URL="https://"
GET_PROJECTS="v1/auth/projects"
CREATE_PROJECT_URL="auth/v1/projects"
GET_USERS="auth/v1/users/-/current/"

MAIN_YAML="$PWD/values.yaml"

PROJECT_HASH=""
PROJECT_NAME_FIELD="projectName"

function merge_yaml_files () {
    local localYamlFile="$1"
    local tempYamlFile="$2"

    merged_yaml=$(yq eval-all 'select(fileIndex == 0) + select(fileIndex == 1)' "$localYamlFile" "$MAIN_YAML")
    echo "$merged_yaml" > "$tempYamlFile" || { 
        printf -- "\033[31m ERROR: Failed to write merged YAML %s \033[0m\n" "$tempYamlFile";
        exit 1
    }
}

# check for required binaries
function check_required_binaries () {
    for i in docker docker-compose git grep awk jq yq rctl
    do
        type $i > /dev/null 2>&1 || \
            { printf -- "\033[31m ERROR: Required binary $i is missing. - FAILED \033[0m\n"; exit 1; }
    done

    if docker info &>/dev/null; then
        echo "Docker is running."
    else
        printf -- "\033[31m ERROR: Docker is not running. Ensure the docker is running from where the script is executed \033[0m\n";
        exit 1
    fi

    rctl config show >/dev/null
    if [ $? -ne 0 ]; then
        printf -- "\033[31m ERROR: Initialize the rctl \033[0m\n";
    fi
}

# POST request for HUB apis
function make_get_request_new {
    local endpoint="$1"
    curl -s -X GET -H "Accept */*" -H "X-API-KEY: ${API_KEY}" "${BASE_URL}/${endpoint}"
}

# POST request for old apis
function make_get_request_old {
    local endpoint="$1"
    curl -s --location "${BASE_URL}/${endpoint}" -H "X-RAFAY-API-KEYID: ${API_KEY}"
}

# POST request for HUB apis
function make_post_request_new {
    local endpoint="$1"
    local data_file="$2"
    #echo "${BASE_URL}/${endpoint}"
    curl -s -X POST -H "Content-Type: application/json" -H "X-API-KEY: ${API_KEY}" -d "@${data_file}" "${BASE_URL}/${endpoint}" 
}

# POST request for old apis
function make_post_request_old {
    local endpoint="$1"
    local data_file="$2"
    #echo "${BASE_URL}/${endpoint}"
    curl -s -X POST -H "Content-Type: application/json" -H "X-RAFAY-API-KEYID: ${API_KEY}" -d "@${data_file}" "${BASE_URL}/${endpoint}"
}

# creates project
function create_project {
    curl -s -X POST -H "Content-Type: application/json" -H "X-RAFAY-API-KEYID: ${API_KEY}" -d "{\"name\":\"${PROJECT_NAME}\",\"description\":\"Project for templates\"}" "${BASE_URL}/$CREATE_PROJECT_URL/" | jq > project_response.json
    PROJECT_HASH=$(cat project_response.json | jq -r '.id')
    echo "Successfully created project ${PROJECT_NAME} id ${PROJECT_HASH}"
}

# creates sealers
function create_sealers {
    local templatefile="$1"
    echo "Creating secret sealer for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/values.yaml > $PWD/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/tmp.yaml \
        --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/tmp.yaml \
        --test-template --write $PWD/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/templates/$fName.yaml.spec > $PWD/templates/$fName.json 

    jq 'del(.apiVersion, .kind, .metadata.project)' $PWD/templates/$fName.json > $PWD/templates/$fName.json1

    local response=$(make_post_request_old "$ADD_SECRETSEALER_TEMPLATE" $PWD/templates/$fName.json1)

    if [[ $response == *"\"error\""* ]]; then
       error_message=$(echo "$response" | jq -r '.error')
       printf -- "\033[31m ERROR: Failed to create secret sealer %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created secret sealer successfully \033[0m\n";
    fi

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/tmp.yaml"
        rm -f "$PWD/templates/$fName.json"
        rm -f "$PWD/templates/$fName.json1"
        rm -f "$PWD/templates/$fName.yaml.spec"
    fi
}

# creates configcontext templates
function create_configcontext_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating you configcontext for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values_tmp.yaml > $PWD/$folder/setup/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) ' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi

    local response=$(make_post_request_new "$ADD_CONFIGCONTEXT_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1)

    if [[ $response == *"\"internal\""* ]]; then
       error_message=$(echo "$response" | jq -r '.internal')
       printf -- "\033[31m ERROR: Failed to create config context %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created config context successfully \033[0m\n";
    fi

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/$folder/setup/tmp.yaml"
        rm -f "$PWD/$folder/setup/templates/$fName.json"
        rm -f "$PWD/$folder/setup/templates/$fName.json1"
        rm -f "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi
}

# creates driver templates
function create_driver_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating you driver for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values_tmp.yaml > $PWD/$folder/setup/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents, .spec.contexts)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    
    local response=$(make_post_request_new "$ADD_DRIVER_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1)

    if [[ $response == *"\"error\""* ]]; then
       error_message=$(echo "$response" | jq -r '.error')
       printf -- "\033[31m ERROR: Failed to create driver %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created driver successfully \033[0m\n";
    fi

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/$folder/setup/tmp.yaml"
        rm -f "$PWD/$folder/setup/templates/$fName.json"
        rm -f "$PWD/$folder/setup/templates/$fName.json1"
        rm -f "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi
}

# creates resource templates
function create_resource_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating resource template for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values_tmp.yaml > $PWD/$folder/setup/tmp.yaml
    


    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi
    
    local response=$(make_post_request_new "$ADD_RESOURCE_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1)

    if [[ $response == *"\"internal\""* ]]; then
       error_message=$(echo "$response" | jq -r '.internal')
       printf -- "\033[31m ERROR: Failed to create resoure template %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created resource template successfully \033[0m\n";
    fi

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/$folder/setup/tmp.yaml"
        rm -f "$PWD/$folder/setup/templates/$fName.json"
        rm -f "$PWD/$folder/setup/templates/$fName.json1"
        rm -f "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi
}

# creates environment templates
function create_environment_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating environment template for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values_tmp.yaml > $PWD/$folder/setup/tmp.yaml

    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) ' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi
    
    local response=$(make_post_request_new "$ADD_ENVIRONMENT_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1)

    if [[ $response == *"\"internal\""* ]]; then
       error_message=$(echo "$response" | jq -r '.internal')
       printf -- "\033[31m ERROR: Failed to create environment template %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created environment template successfully \033[0m\n";
    fi

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/$folder/setup/tmp.yaml"
        rm -f "$PWD/$folder/setup/templates/$fName.json"
        rm -f "$PWD/$folder/setup/templates/$fName.json1"
        rm -f "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi
}

# reads the spec files in the template folder
function read_folder {
    local folder="$1"

    local configcontext_templates=()
    local driver_templates=()
    local resource_templates=()
    local environment_templates=()

    #cat "$folder/setup/values.yaml"

    merge_yaml_files "$folder/setup/values.yaml" "$folder/setup/values_tmp.yaml"

    # Searching for configcontext
    while IFS= read -r -d '' file; do
        if [[ "$file" == *.tmpl ]]; then
            configcontext_templates+=("$file")
        fi
    done < <(grep -lr --null "kind: ConfigContext" "$folder")

    echo "Configcontext templates in '$folder':"
    for file in "${configcontext_templates[@]}"; do
        printf -- "\033[32m %s\033[0m\n" "$file"
        create_configcontext_templates "$file" "$folder"
    done

    # Searching for driver
    while IFS= read -r -d '' file; do
        if [[ "$file" == *.tmpl ]]; then
            driver_templates+=("$file")
        fi
    done < <(grep -lr --null "kind: Driver" "$folder")

    echo "Driver templates in '$folder':"
    for file in "${driver_templates[@]}"; do
        printf -- "\033[32m %s\033[0m\n" "$file"
        create_driver_templates "$file" "$folder"
    done

    # Searching for resource templates
    while IFS= read -r -d '' file; do
        if [[ "$file" == *.tmpl ]]; then
            resource_templates+=("$file")
        fi
    done < <(grep -lr --null "kind: ResourceTemplate" "$folder")

    echo "Resource templates in '$folder':"
    for file in "${resource_templates[@]}"; do
        printf -- "\033[32m %s\033[0m\n" "$file"
        create_resource_templates "$file" "$folder"
    done

   
    # Searching for environment templates
    while IFS= read -r -d '' file; do
        if [[ "$file" == *.tmpl ]]; then
            environment_templates+=("$file")
        fi
    done < <(grep -lr --null "kind: EnvironmentTemplate" "$folder")

    echo "Environment templates in '$folder':"
    for file in "${environment_templates[@]}"; do
        printf -- "\033[32m %s\033[0m\n" "$file"
        create_environment_templates "$file" "$folder"
    done

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$folder/setup/values_tmp.yaml"
    fi
}

# creates pipeline
function create_pipeline {
    local templatefile="$1"
    echo "Creating pipeline for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/values.yaml > $PWD/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/tmp.yaml \
        --test-template | grep -m1 -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/tmp.yaml \
        --test-template --write $PWD/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$templatefile";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$templatefile";
    fi
    
    yq -o=json $PWD/templates/$fName.yaml.spec > $PWD/templates/$fName.json 
    

    local response=$(make_post_request_new "$ADD_PIPELINE_URL" $PWD/templates/$fName.json)

    if [[ $response == *"\"error\""* ]]; then
       error_message=$(echo "$response" | jq -r '.error')
       printf -- "\033[31m ERROR: Failed to pipeline %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created pipeline successfully \033[0m\n";
    fi

    triggerName=$(cat $PWD/templates/$fName.json  | jq -r '.spec.triggers[0].name')

    GET_PIPELINE_URL="v2/pipeline/project/${PROJECT_HASH}/trigger/${triggerName}"
    make_get_request_old "$GET_PIPELINE_URL" | jq > templates/trigger_response.json

    webHookURL=$(cat $PWD/templates/trigger_response.json  | jq -r '.status.extra.webHook.webHookURL')
    webHookSecret=$(cat $PWD/templates/trigger_response.json  | jq -r '.status.extra.webHook.webHookSecret')

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f "$PWD/tmp.yaml"
        rm -f "$PWD/templates/$fName.json"
        rm -f "$PWD/templates/$fName.yaml.spec"
    fi
    echo "Successfully created pipelines"
}

function create_agent() {
    # Create agent
    echo "Creating agent"
    AGENT_NAME=$AGENT_NAME-$PROJECT_NAME

    ADD_AGENT_URL="v2/config/project/${PROJECT_HASH}/agent"
    GET_AGENT_URL="v2/config/project/${PROJECT_HASH}/agent/{$AGENT_NAME}"

    jq --arg name "$AGENT_NAME" '(.metadata.name |= $name)' templates/agent_template.json > templates/agent.json

    local response=$(make_post_request_old "$ADD_AGENT_URL" templates/agent.json)

    if [[ $response == *"\"error\""* ]]; then
       error_message=$(echo "$response" | jq -r '.error')
       printf -- "\033[31m ERROR: Failed to create agent %s \033[0m\n" "$error_message";
    else
       printf -- "\033[32m Info: Created agent successfully \033[0m\n";
    fi

    make_get_request_old "$GET_AGENT_URL" | jq > templates/agents_response.json
    agentId=$(cat templates/agents_response.json | jq -r '.metadata.id')
    agentStatus=$(cat templates/agents_response.json | jq -r '.status.health.status')

    GET_RELAY_CONFIG_URL="v2/config/project/${PROJECT_HASH}/agent/${AGENT_NAME}/relay-config"
    make_get_request_old "$GET_RELAY_CONFIG_URL" | jq > "relayConfigData-$agentId.json"
    GET_DOCKER_COMPOSE_URL="v2/config/project/${PROJECT_HASH}/agent/${AGENT_NAME}/docker-compose"
    make_get_request_old "$GET_DOCKER_COMPOSE_URL" > "docker-compose-$agentId.yaml"

    ##Run docker-compose
    if ! docker-compose -f $PWD/docker-compose-$agentId.yaml up -d ; then
        printf -- "\033[31m ERROR: Failed to deploy agent  - FAILED \033[0m\n";
        exit
    else
        printf -- "\033[32m Info: Agent deployed - SUCCESS \033[0m\n";
    fi

    ##Wait for gitops agent to be healthy
    STATUS_ITERATIONS=1
    while [ $agentStatus != "HEALTHY" ]
    do
        sleep 30
        if [ $STATUS_ITERATIONS -ge 25 ];
        then
            break
            exit 0
        fi
        STATUS_ITERATIONS=$((STATUS_ITERATIONS+1))
        make_get_request_old "$GET_AGENT_URL" | jq > templates/agents_response.json
        agentStatus=$(cat templates/agents_response.json | jq -r '.status.health.status')
        if [ $agentStatus != "HEALTHY" ]; then
            printf -- "\033[33m Warn: Agent Status $agentStatus   - WAITING \033[0m\n";
        else
            printf -- "\033[32m Info: Agent Status $agentStatus   - SUCCESS \033[0m\n";
        fi
    done

    rm -f "docker-compose-$agentId.yaml"
    rm -f "relayConfigData-$agentId.json"
}

# Create Repo and pipeline
function create_repository() {
    if [ "$IS_PRIVATE_REPO" = false ]; then
        echo "Creating public repo"
        jq --arg name "$REPO_NAME" --arg agentname "$AGENT_NAME" '(.metadata.name |= $name) | (.spec.agentNames = [$agentname]) | del(.spec.credentials)' templates/repository_template.json > templates/repository.json
        make_post_request_old "$ADD_REPO_URL" templates/repository.json
        echo ""
        echo "Successfully created repo"
    else
        echo "Creating private repo"
        CRED_TYPE="UserPassCredential"
        jq --arg name "$REPO_NAME" --arg endpoint "$END_POINT" --arg agentname "$AGENT_NAME" --arg username "$USER_NAME" --arg token "$TOKEN" --arg credType "$CRED_TYPE" '(.metadata.name |= $name) | (.spec.endpoint = $endpoint) | (.spec.agentNames = [$agentname]) | (.spec.credentials.userPass.username = $username) | (.spec.credentials.userPass.password = $token) | (.spec.credentialType = $credType)' templates/repository_template.json > templates/repository.json
        make_post_request_old "$ADD_REPO_URL" templates/repository.json
        echo ""
        echo "Successfully created repo"

        create_pipeline "templates/03-pipeline.tmpl" 
    fi
}

# create project if not exist
function create_common_resources() {
    # get the project hash for the given org
    make_get_request_old "$GET_PROJECTS" | jq > templates/project_response.json

    echo "Successfully retrieved projects"

    # get the project id
    PROJECT_HASH=$(cat templates/project_response.json | jq -r --arg project_name "$PROJECT_NAME" '.results[] | select(.name == $project_name) | .id')
    if [ -z "$PROJECT_HASH" ]; then
        echo "Project $PROJECT_NAME does not exist. Creating project.."
        create_project
        sleep 5
    else 
        echo "Project hash $PROJECT_HASH"
    fi

    ADD_SECRETSEALER_TEMPLATE="v2/config/project/${PROJECT_HASH}/secretsealer"
    ADD_REPO_URL="v2/config/project/${PROJECT_HASH}/repository"
    #ADD_PIPELINE_URL="v2/pipeline/project/${PROJECT_HASH}/pipeline"
    ADD_PIPELINE_URL="apis/gitops.k8smgmt.io/v3/projects/${PROJECT_NAME}/pipelines"
    
    # Create sealer
    create_sealers "templates/00-sealer.tmpl" 

    create_agent

    create_repository
}

function create_templates() {
    for folder in "${templates[@]}"; do
        if [ -d "$folder" ]; then
            read_folder "$folder"
        else
            echo "Template $folder does not exist"
        fi
    done
}

# reads values.yaml
function read_values_yaml() {
    echo "Reading values yaml"

    hostenv=$(cat values.yaml | yq e '.hostenv')
    BASE_URL="${BASE_URL}${hostenv}"
    API_KEY=$(cat values.yaml |yq e '.apikey')
    REPO_NAME=$(cat values.yaml | yq e '.repoName')
    PROJECT_NAME=$(cat values.yaml | yq e '.projectName')
    AGENT_NAME=$(cat values.yaml | yq e '.agentName')
    ORG_NAME=$(cat values.yaml | yq e '.org')

    SHARING=$(cat values.yaml | yq e '.sharingtemplates')
    IS_PRIVATE_REPO=$(cat values.yaml | yq e '.isPrivateRepo')
    USER_NAME=$(cat values.yaml | yq e '.userName')
    TOKEN=$(cat values.yaml | yq e '.token')
    END_POINT=$(cat values.yaml | yq e '.endPoint')
    PATH_VAL=$(cat values.yaml | yq e '.path')

    if [ -z "$API_KEY" ] || [ "$API_KEY" = "UPDATE_API_KEY" ]; then
        printf -- "\033[31m ERROR: Please update valid apikey in values.yaml \033[0m\n";
        exit 1
    fi

    if [ -z "$ORG_NAME" ] || [ "$ORG_NAME" = "UPDATE_ORG_NAME" ]; then
        printf -- "\033[31m ERROR: Please update valid org in values.yaml \033[0m\n";
        exit 1
    fi
    
    if [ -z "$PROJECT_NAME" ] || [ "$PROJECT_NAME" = "UPDATE_PROJECT_NAME" ]; then
        printf -- "\033[31m ERROR: Please update valid projectName in values.yaml \033[0m\n";
        exit 1
    fi

    if [ "$IS_PRIVATE_REPO" = true ]; then
        if [ -z "$USER_NAME" ] || [ "$USER_NAME" = "UPDATE_USER_NAME" ]; then
            printf -- "\033[31m ERROR: Please update valid userName in values.yaml \033[0m\n";
            exit 1
        fi

        if [ -z "$TOKEN" ] || [ "$TOKEN" = "UPDATE_TOKEN" ]; then
            printf -- "\033[31m ERROR: Please update valid token in values.yaml \033[0m\n";
            exit 1
        fi

        if [ -z "$END_POINT" ] || [ "$END_POINT" = "UPDATE_END_POINT" ]; then
            printf -- "\033[31m ERROR: Please update valid token in values.yaml \033[0m\n";
            exit 1
        fi

        if [ -z "$PATH_VAL" ] || [ "$PATH_VAL" = "UPDATE_PATH" ]; then
            printf -- "\033[31m ERROR: Please update valid path in values.yaml \033[0m\n";
            exit 1
        fi
    fi


    validate_orgname "$ORG_NAME"

    templates=($(cat values.yaml | yq e '.templates[]'))

    ADD_RESOURCE_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/resourcetemplates"
    ADD_ENVIRONMENT_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/environmenttemplates"
    ADD_DRIVER_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/drivers"
    ADD_CONFIGCONTEXT_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/configcontexts?fail-on-exists=true"

    #for template in "${templates[@]}"; do
    #    echo "$template"
    #done
}

# checks api users org name with the org name from values.yaml to avoid making accidental changes
function validate_orgname() {
    local orgname="$1"
    echo "Validating organization"
    make_get_request_old "$GET_USERS" | jq > templates/users_response.json
    USER_ORG=$(cat templates/users_response.json | jq '.organization.name' | sed 's/"//g') 
     
    echo "API key belongs to org ${USER_ORG}"

    if [ "$orgname" != "$USER_ORG" ]; then
        echo "API key does not belong to the org ${orgname} - It belongs to different org ${USER_ORG}"
        exit 1
    fi
}

main() {
    # check required binaries
    check_required_binaries

    read_values_yaml

    # creates project, sealers, agents, repo and pipeline
    create_common_resources

    # create templates
    create_templates

    # cleanup the tmp files
    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm -f templates/users_response.json
        rm -f templates/project_response.json
        rm -f templates/trigger_response.json
        rm -f templates/agents_response.json
        rm -f templates/repository.json
        rm -f templates/agent.json
    fi 

    if [ "$IS_PRIVATE_REPO" = true ]; then
        echo ""
        echo "====================================================="
        echo "Webhook        --> $webHookURL"
        echo "Webhook Secret --> $webHookSecret"
        echo "====================================================="
    fi
}

## entry point 
main "$@"
