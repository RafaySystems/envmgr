# Self-Service Environment Template

This repository serves as a **reference design and implementation** for creating self-service developer environments within a cluster running on **VMware vSphere Infrastructure**. The implementation is based on Rafay's Kubernetes Manager and Environment Manager.

## Configuration

In this step, you will set up a values file that will be used by a configuration script.

1. Open the `values.yaml` file:

```yaml
project: UPDATE_EXISTING_PROJECT_NAME
userName: UPDATE_REPO_USERNAME
token: UPDATE_REPO_TOKEN
endPoint: UPDATE_REPO_ENDPOINT
branch: UPDATE_REPO_BRANCH
```

1. Replace the placeholder values (UPDATE_EXISTING_PROJECT_NAME, UPDATE_REPO_USERNAME, UPDATE_REPO_TOKEN, UPDATE_REPO_ENDPOINT, UPDATE_REPO_BRANCH) with your specific configuration.
2. Save the file.


This values file will be utilized by the configuration script during the setup process. Feel free to adjust any other settings as needed to match your requirements.
