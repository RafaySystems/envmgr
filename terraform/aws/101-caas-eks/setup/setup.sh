#!/bin/bash

#set -ex

spec_array=()
## Directory to store generated spec for Rafay resources.
mkdir -p spec

function check_required_binaries () {
  ##check for docker docker-compose rctl grep awk jq base64
  for i in docker docker-compose git rctl grep awk jq base64
  do
    type $i > /dev/null 2>&1 || \
        { printf -- "\033[31m ERROR: Required binary $i is missing. - FAILED \033[0m\n"; exit 1; }
  done
}

function check_rctl_initialize () {
  ##rctl config show > /dev/null 2>&1
  if ! rctl config show > /dev/null 2>&1 ; then
    printf -- "\033[31m ERROR: Initialize RCTl is required. |\
     Documentation : https://docs.rafay.co/cli/config/#initialize - FAILED \033[0m\n";
    exit
  fi
}

function manual_steps() {
    printf -- "\n\n\033[36m Info: Run Following Step manually..\n \033[0m\n - \
  \033[36m Setup webhook in Github using above info \033[0m \033[0m\n - \
  \033[36m Remove repo token from the values.yaml \033[0m\n - \
  \033[36m Run git push \033[0m\n - \
  \033[36m Update Context resources in controller UI with credentials\033[0m\n - \
  \033[36m Create Environment resource using existing Environment Template\033[0m\n - \
  \033[36m Publish Environment\033[0m\n\ "
  exit 0
}

function test_eaas() {
    printf -- "\n\n\033[36m Info: Run Following Step manually..\n \033[0m\n - \
  \033[36m Update Context resources in controller UI with credentials\033[0m\n - \
  \033[36m Create Environment resource using existing Environment Template\033[0m\n - \
  \033[36m Publish Environment\033[0m\n\ "
}

##Check if required binaries are avaialble.
check_required_binaries
printf -- "\033[32m Info: Required binaries are installed - SUCCESS \033[0m\n";
##Check rctl setup
check_rctl_initialize
printf -- "\033[32m Info: Check RCTL (Rafay CLI) setup    - SUCCESS \033[0m\n";

##Find projectName from values.yaml
project=`cat $PWD/values.yaml | awk '/projectName/ {print $2}'`
userName=`cat $PWD/values.yaml | awk '/usernName/ {print $2}'`
token=`cat $PWD/values.yaml | awk '/token/ {print $2}'`
endpoint=`cat $PWD/values.yaml | awk '/endPoint/ {print $2}' | awk -F// '{print $2}'`
branch=`cat $PWD/values.yaml | awk '/branch/ {print $2}'`

##Generate Spec files based on available templates.
for i in templates/*.tmpl
do
  ##filename based on user's input (values.yaml)
  fName="$(rctl apply -t $i --values $PWD/values.yaml \
           --test-template | grep -A3 metadata | awk  '/name/ {print $2}')" 

  ##Remove existing file
  rm -rf $PWD/spec/$fName.yaml

  ##Generate spec using rctl
  if ! rctl apply -t $i --values $PWD/values.yaml \
       --test-template --write $PWD/spec/$fName.yaml ; then
      printf -- "\033[31m ERROR: Rafay spec file for $i failed - FAILED \033[0m\n";
      exit
  else
      printf -- "\033[32m Info: Rafay spec file for $i  - SUCCESS \033[0m\n";
      spec_array[${#spec_array[@]}]=$fName

  fi
done

if ! git restore $PWD/values.yaml; then
    printf -- "\033[31m ERROR: Failed to restore values.yaml- FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: Restored values.yaml - SUCCESS \033[0m\n";
fi
printf -- "\033[32m Info: Restore Values.yaml - SUCCESS \033[0m\n";

##Create Secret Sealer to encrypt sensitive data(i.e password)
if ! rctl apply -f $PWD/spec/${spec_array[0]}.yaml ; then
    printf -- "\033[31m ERROR: Failed to create secret-sealer  - FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: Secret-sealer created  - SUCCESS \033[0m\n";
fi

##Create and deploy Gitops Agent
if ! rctl apply -f $PWD/spec/${spec_array[1]}.yaml ; then
#if ! rctl create agent -p $project -f $PWD/spec/${spec_array[1]}.yaml --run ; then
    printf -- "\033[31m ERROR: Failed to create gitops agent - FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: Gitops agent created  - SUCCESS \033[0m\n";
fi


##Get Gitops Agent ID
sleep 5
agentId=`rctl get agent -p $project ${spec_array[1]} -o json  | jq .metadata.id | tr -d '"'`
if [ -z "$agentId" ]; then
  printf -- "\033[31m ERROR: Failed to get agent ID - FAILED \033[0m\n";
  exit
fi 


rm -rf relayConfigData-$agentId.json docker-compose-$agentId.yaml
##Download agent config files
rctl get agent -p $project ${spec_array[1]} -o json --v3 | \
 jq -r -c '.status.extra.files[] | select ( .name == "relayConfigData-'$agentId'.json" ) | .data'| \
 base64 -d >> $HOME/relayConfigData-$agentId.json

rctl get agent -p $project ${spec_array[1]} -o json --v3 \
| jq -r -c '.status.extra.files[] | select ( .name == "docker-compose-'$agentId'.yaml" ) | .data' | \
base64 -d >> $HOME/docker-compose-$agentId.yaml


##Run docker-compose
if ! docker-compose -f $HOME/docker-compose-$agentId.yaml up -d ; then
   printf -- "\033[31m ERROR: Failed to deploy agent  - FAILED \033[0m\n";
   exit
else
   printf -- "\033[32m Info: Agent deployed - SUCCESS \033[0m\n";
fi

##Wait for gitops agent to be healthy
STATUS_ITERATIONS=1
agentStatus=`rctl get agent -p $project ${spec_array[1]} -o json --v3 | jq .status.conditionType | tr -d '"'`
while [ $agentStatus != "AgentHealthy" ]
do
    sleep 30
    if [ $STATUS_ITERATIONS -ge 25 ];
    then
      break
      exit 0
    fi
    STATUS_ITERATIONS=$((STATUS_ITERATIONS+1))
    agentStatus=`rctl get agent -p $project ${spec_array[1]} -o json --v3 | jq .status.conditionType | tr -d '"'`
    if [ $agentStatus != "AgentHealthy" ]; then
        printf -- "\033[33m Warn: Agent Status $agentStatus   - WAITING \033[0m\n";
    else
        printf -- "\033[32m Info: Agent Status $agentStatus   - SUCCESS \033[0m\n";
    fi
done

##Create Repository
if ! rctl apply -f $PWD/spec/${spec_array[2]}.yaml ; then
    printf -- "\033[31m ERROR: Failed to create repository  - FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: Repository created  - SUCCESS \033[0m\n";
fi

##Create Pipeline
if ! rctl apply -f $PWD/spec/${spec_array[3]}.yaml ; then
      printf -- "\033[31m ERROR: Failed to create pipeline  - FAILED \033[0m\n";
      exit
  else
      printf -- "\033[32m Info: Pipeline created  - SUCCESS \033[0m\n";
fi

printf -- "\033[33m Info: Wait for 30s for Rafay to write-back to repo - WAITING \033[0m\n";
sleep 30
#Run git pull to get folder structure created by Rafay
#Create Pipeline
if ! git pull https://$userName:$token@$endpoint $branch; then
    printf -- "\033[31m ERROR: git pull - FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: git pull - SUCCESS \033[0m\n";
fi

##Move eaas service under rafay-resource folder.
mkdir -p ../../../../rafay-resources/projects/$project/configcontexts
cp $PWD/spec/${spec_array[4]}.yaml  ../../../..//rafay-resources/projects/$project/configcontexts/
cp $PWD/spec/${spec_array[5]}.yaml  ../../../..//rafay-resources/projects/$project/configcontexts/
mkdir -p ../../../../rafay-resources/projects/$project/resourcetemplates
cp $PWD/spec/${spec_array[6]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[7]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[8]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[9]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[10]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[11]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[12]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[13]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
cp $PWD/spec/${spec_array[14]}.yaml  ../../../../rafay-resources/projects/$project/resourcetemplates/
mkdir -p ../../../../rafay-resources/projects/$project/environmenttemplates
cp $PWD/spec/${spec_array[15]}.yaml  ../../../../rafay-resources/projects/$project/environmenttemplates/
#mkdir -p ../../../../rafay-resources/projects/$project/environments
#cp $PWD/spec/${spec_array[16]}.yaml  ../../../../rafay-resources/projects/$project/environments/

rm -rf $PWD/spec

sleep 5

rctl get trigger -p $project  eaas-trigger -o json | jq .status.extra.webHook

read -p "Once done setting up above webhook, reply to continue - (Yes/No)" answer
echo
while [ "$answer" != "Yes" ] && [ "$answer" != "No" ]; do
    echo "Answer Yes Or No"
    read -p "Reply Yes/No to continue - (Yes/No)" answer
done

if [ "$answer" == "No" ]; then
    manual_steps
fi

git add -A; git commit -m "Getting started with Rafay EM"
if ! git push https://$userName:$token@$endpoint $branch; then
    printf -- "\033[31m ERROR: git push - FAILED \033[0m\n";
    exit
else
    printf -- "\033[32m Info: git push - SUCCESS \033[0m\n";
fi

test_eaas
