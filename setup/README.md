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

**Note**: Project name will be suffixed for the agent name

**repoName** - Repository name
> Default value - eaas-repo

**isPrivateRepo** - This value should be set to true if the customer creates the private repository.

**userName** - User name of the git repository

**token** - Token for authenticating to the git repository

**endPoint** - Update the end point of the cloned repository.

**branch** - Update which branch the repository should be pointing to.

**path** - Repository path for pipeline to write back configuration

**version** - Version of the templates

**sharingtemplates** - Set to true if the templates need to be shared across the projects.

- **How to Run**
> ./createtemplates.sh