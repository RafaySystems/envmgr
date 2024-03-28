# About

This setup script will help to deploy the current existing templates in this repo

- **Prerequisites**
Below binaries are required to run the script.
> docker docker-compose git grep awk jq yq rctl

- **Update the values.yaml**

**hostenv** - Host Environment
> Default value - console.rafay.dev

**apikey** - Provide the API key

**org** - Provide the org name of the API key

**projectName** - Provide the project name where the templates will be created. 
> Default value - defaultproject

**agentName** - Agent name 
> Default value - eaas-agent

**repoName** - Repository name
> Default value - eaas-repo

**isClonedRepo** - This value should be set to true if the customer wants to create the repo pointing to the cloned repo.

**userName** - User name of the git repo

**token** - Token for authenticating to the git repo

**endPoint** - Update the end point of the cloned repo.

**branch** - Update which brach the repo should be pointing to.

**path** - Repository path for Rafay to write back configuration

**version** - Version of the templates

**sharingtemplates** - Set to true if the templates need to be shared across the projects.

- **How to Run**
> ./createtemplates.sh