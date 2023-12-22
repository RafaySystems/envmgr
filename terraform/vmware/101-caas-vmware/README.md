# Self-Service Environment Template

This repository serves as a **reference design and implementation** for creating self-service developer environments within a cluster running on **VMware vSphere Infrastructure**. The implementation is based on Rafay's Kubernetes Manager and Environment Manager.

## Configuration

To customize the environment, update the parameters in the `values.yaml` file:

```yaml
project: UPDATE_EXISTING_PROJECT_NAME
userName: UPDATE_REPO_USERNAME
token: UPDATE_REPO_TOKEN
endPoint: UPDATE_REPO_ENDPOINT
branch: UPDATE_REPO_BRANCH
