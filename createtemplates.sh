#!/bin/bash

# input from values.yaml
API_KEY=
PROJECT_NAME="templates"
REPO_NAME="rafay-repository"
CLEANUP_TEMP_FILES=true
SHARING=true
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
ADD_RESOURCE_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/resourcetemplates"
ADD_ENVIRONMENT_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/environmenttemplates"
ADD_DRIVER_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/drivers"
ADD_CONFIGCONTEXT_TEMPLATE="apis/eaas.envmgmt.io/v1/projects/${PROJECT_NAME}/configcontexts"
CREATE_PROJECT_URL="auth/v1/projects"
GET_USERS="auth/v1/users"

PROJECT_HASH=""
PROJECT_NAME_FIELD="projectName"


# check for required binaries yq jq
function check_required_binaries () {
    for i in yq jq
    do
        type $i > /dev/null 2>&1 || \
            { printf -- "\033[31m ERROR: Required binary $i is missing. - FAILED \033[0m\n"; exit 1; }
    done
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
    echo "${BASE_URL}/${endpoint}"
    curl -s -X POST -H "Content-Type: application/json" -H "X-API-KEY: ${API_KEY}" -d "@${data_file}" "${BASE_URL}/${endpoint}" 
}

# POST request for old apis
function make_post_request_old {
    local endpoint="$1"
    local data_file="$2"
    echo "${BASE_URL}/${endpoint}"
    curl -s -X POST -H "Content-Type: application/json" -H "X-RAFAY-API-KEYID: ${API_KEY}" -d "@${data_file}" "${BASE_URL}/${endpoint}" 
}

# creates configcontext templates
function create_project {
    curl -s -X POST -H "Content-Type: application/json" -H "X-RAFAY-API-KEYID: ${API_KEY}" -d "{\"name\":\"${PROJECT_NAME}\",\"description\":\"Project for templates\"}" "${BASE_URL}/$CREATE_PROJECT_URL/" | jq > project_response.json
    PROJECT_HASH=$(cat project_response.json | jq -r '.id')
    echo "Successfully created project ${PROJECT_NAME} id ${PROJECT_HASH}"
}

# creates configcontext templates
function create_configcontext_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating you configcontext for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values.yaml > $PWD/$folder/setup/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$i";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$i";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents, .spec.files)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents, .spec.files)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi
    
    make_post_request_new "$ADD_CONFIGCONTEXT_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm "$PWD/$folder/setup/tmp.yaml"
        rm "$PWD/$folder/setup/templates/$fName.json"
        rm "$PWD/$folder/setup/templates/$fName.json1"
        rm "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi

    echo "Successfully created configcontext"
}

# creates driver templates
function create_driver_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating you driver for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values.yaml > $PWD/$folder/setup/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$i";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$i";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents, .spec.contexts)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    make_post_request_new "$ADD_DRIVER_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm "$PWD/$folder/setup/tmp.yaml"
        rm "$PWD/$folder/setup/templates/$fName.json"
        rm "$PWD/$folder/setup/templates/$fName.json1"
        rm "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi

    echo "Successfully created driver"
}

# creates resource templates
function create_resource_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating resource template for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values.yaml > $PWD/$folder/setup/tmp.yaml
    
    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -A1 metadata | awk  '/name/ {print $2}')" 

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$i";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$i";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents)' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi
    
    make_post_request_new "$ADD_RESOURCE_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm "$PWD/$folder/setup/tmp.yaml"
        rm "$PWD/$folder/setup/templates/$fName.json"
        rm "$PWD/$folder/setup/templates/$fName.json1"
        rm "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi

    echo "Successfully created resource"
}

# creates environment templates
function create_environment_templates {
    local templatefile="$1"
    local folder="$2"
    echo "Creating environment template for ${templatefile}"

    sed "s/^$PROJECT_NAME_FIELD: .*$/$PROJECT_NAME_FIELD: $PROJECT_NAME/" $PWD/$folder/setup/values.yaml > $PWD/$folder/setup/tmp.yaml

    fName="$(rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
           --test-template | grep -A1 metadata | awk  '/name/ {print $2}')" 

    rm "$PWD/$folder/setup/templates/$fName.json"
    rm "$PWD/$folder/setup/templates/$fName.json1"
    rm "$PWD/$folder/setup/templates/$fName.yaml.spec"

    if ! rctl apply -t $templatefile --values $PWD/$folder/setup/tmp.yaml \
        --test-template --write $PWD/$folder/setup/templates/$fName.yaml.spec ; then
        printf -- "\033[31m ERROR: Rafay spec file for %s failed - FAILED \033[0m\n" "$i";
        exit
    else
        printf -- "\033[32m Info: Rafay spec file for %s - SUCCESS \033[0m\n" "$i";
    fi
    
    yq -o=json $PWD/$folder/setup/templates/$fName.yaml.spec > $PWD/$folder/setup/templates/$fName.json 

    if [ "$SHARING" = true ]; then
        jq --arg repo_name "$REPO_NAME" '.spec += { "sharing": { "enabled": true, "projects": [{ "name": "*" }] } } | (.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents) ' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    else
        jq --arg repo_name "$REPO_NAME" '(.spec.repositoryOptions.name |= $repo_name) | del(.spec.agents) ' $PWD/$folder/setup/templates/$fName.json > $PWD/$folder/setup/templates/$fName.json1
    fi
    
    make_post_request_new "$ADD_ENVIRONMENT_TEMPLATE" $PWD/$folder/setup/templates/$fName.json1

    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm "$PWD/$folder/setup/tmp.yaml"
        rm "$PWD/$folder/setup/templates/$fName.json"
        rm "$PWD/$folder/setup/templates/$fName.json1"
        rm "$PWD/$folder/setup/templates/$fName.yaml.spec"
    fi

    echo "Successfully created environment template"
}

# reads the spec files in the template folder
function read_folder {
    local folder="$1"

    local configcontext_templates=()
    local driver_templates=()
    local resource_templates=()
    local environment_templates=()

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
}

# create project if not exist
function createproject() {
    # get the project hash for the given org
    make_get_request_old "$GET_PROJECTS" | jq > project_response.json

    echo "Successfully retrieved projects"

    # get the project id
    PROJECT_HASH=$(cat project_response.json | jq -r --arg project_name "$PROJECT_NAME" '.results[] | select(.name == $project_name) | .id')
    if [ -z "$PROJECT_HASH" ]; then
        echo "Project $PROJECT_NAME does not exist. Creating project.."
        create_project
    else 
        echo "Project hash $PROJECT_HASH"
    fi

    ADD_REPO_URL="v2/config/project/${PROJECT_HASH}/repository"

    # Create Repo without agent
    echo "Creating repo"
    jq --arg name "$REPO_NAME" '(.metadata.name |= $name)' repository_template.json > repository.json
    make_post_request_old "$ADD_REPO_URL" repository.json
    echo "Successfully created repo"
}

function createtemplates() {
    for folder in "${templates[@]}"; do
        if [ -d "$folder" ]; then
            read_folder "$folder"
        else
            echo "Template $folder does not exist"
        fi
    done
}

# reads values.yaml
function readvaluesyaml() {
    echo "Reading values yaml"

    hostenv=$(yq e '.hostenv' values.yaml)
    BASE_URL="${BASE_URL}${hostenv}"

    API_KEY=$(yq e '.apikey' values.yaml)

    REPO_NAME=$(yq e '.repositoryname' values.yaml)

    PROJECT_NAME=$(yq e '.project' values.yaml)

    SHARING=$(yq e '.sharingtemplates' values.yaml)

    ORG_NAME=$(yq e '.org' values.yaml)

    validateorgname $ORG_NAME

    templates=($(yq e '.templates[]' values.yaml))

    for template in "${templates[@]}"; do
        echo "$template"
    done
}

# checks api users org name with the org name from values.yaml to avoid making accidental changes
function validateorgname() {
    local orgname="$1"
    echo "Validating organization"
    make_get_request_old "$GET_USERS" | jq > users_response.json
    USER_ORG=$(cat users_response.json | jq '.organization.name')
    echo "API key belongs to org ${USER_ORG}"

    if [ "$orgname" != "$USER_ORG" ]; then
        echo "API key does not belong to the org ${orgname}"
        exit 1
    fi
}

main() {
    # check required binaries
    check_required_binaries

    readvaluesyaml

    exit 1

    # create project 
    createproject

    # create templates
    createtemplates

    # cleanup the tmp files
    if [ "$CLEANUP_TEMP_FILES" = true ]; then
        rm project_response.json
        rm repository.json
        rm users_response.json
    fi 
}

## entry point 
main "$@"
