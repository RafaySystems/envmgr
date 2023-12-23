# Self-Service Environment Template

This repository serves as a **reference design and implementation** for creating self-service developer environments within a cluster running on **VMware vSphere Infrastructure**. The implementation is based on Rafay's Kubernetes Manager and Environment Manager.

## Configuration

In this step, you will set up a values file located inside the `setup` folder. Follow the steps below:

1. Open the `setup/values.yaml` file:

```yaml
project: UPDATE_EXISTING_PROJECT_NAME
userName: UPDATE_REPO_USERNAME
token: UPDATE_REPO_TOKEN
endPoint: UPDATE_REPO_ENDPOINT
branch: UPDATE_REPO_BRANCH
```

2. Replace the placeholder values (UPDATE_EXISTING_PROJECT_NAME, UPDATE_REPO_USERNAME, UPDATE_REPO_TOKEN, UPDATE_REPO_ENDPOINT, UPDATE_REPO_BRANCH) with your specific configuration.
3. Save the file.


This values file will be utilized by the configuration script during the setup process. Feel free to adjust any other settings as needed to match your requirements.


## Assumptions

1. **Access to VMware vSphere Infrastructure:** Ensure that you have access to the VMware vSphere Infrastructure.

2. **Linux Machine for Rafay GitOps Docker Agent:** Access to any Linux machine within VMware vSphere Infrastructure is required to install the Rafay GitOps Docker agent. This agent facilitates connectivity to the vCenter API, enabling the successful execution of Terraform code.

3. **Git Client Installation:** A Git client must be installed on the machine and configured for push/pull operations.

4. **Docker Installation:** Docker needs to be installed on the machine to support the required functionalities.

For a more detailed, step-by-step guide, refer to the [Rafay Documentation](https://docs.rafay.co/refarch/caas/vmware/101-caas-vmware/overview/)
