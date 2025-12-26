# Terraform Actions with Ansible Automation Platform `aap_job_launch`

# 1. Architecture

High-level architecture

![architecture diagram](./docs/01-architecture/01-architecture-diagram.png)

- Workspace has terraform configurations with the AAP provider using at least [v1.4.0](https://github.com/ansible/terraform-provider-aap/releases/tag/v1.4.0)
- Workspace has access to AAP credentials that allow it to run jobs. In other practical use cases, it also has permissions to register hosts to an inventory before executing a job

Demo architecture creates different workspaces testing different Terraform action scenarios.

![demo diagram](./docs/01-architecture/02-demo-diagram.png)

- HCP Terraform project created with an AAP credentials variable set that contains the AAP credentials as environment variables
- 4 HCP Terraform workspaces are created with different permutations of Terraform [aap_job_launch](https://registry.terraform.io/providers/ansible/aap/latest/docs/actions/job_launch) action. The action references the job template that executes a job.

| Workspace name | wait_for_completion | success |
|----------------|---------------------|---------|
| action-wait-success | true | success |
| action-wait-fail | true | fail |
| action-no-wait-success | false | success |
| action-no-wait-fail | false | fail |

- This demo shows the different UI views depending on the scenario.

# 2. Deployment

Pre-reqs:

- Ansible Automation Platform (AAP) server with credentials

Step 1: In the [tf/01-tf-github-repo-playbook/](./tf/01-tf-github-repo-playbook/) directory, copy [tf/01-tf-github-repo-playbook/terraform.tfvars.example](./tf/01-tf-github-repo-playbook/terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly. GitHub credentials can use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). This token needs sufficient permissions to create, delete repositories, and write files to the repository.

> [!CAUTION]
> In a live environment, it is not good practice to directly pass the GitHub token. Instead, sensitive credentials should be securely stored and accessed using solutions like HashiCorp Vault, which provides encrypted storage and access controls capabilities.

Step 2: In the [tf/01-tf-github-repo-playbook/](./tf/01-tf-github-repo-playbook/) directory, run an apply, review the plan output, and approve the plan accordingly.

```bash
terraform init
terraform apply
```

Step 3: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 4: In [tf/02-ansible-playbook-create/extra_vars.yml](./tf/02-ansible-playbook-create/extra_vars.yml) replace the `scm_url` with the URL to the GitHub repository that has the Ansible playbook. Then run the following to setup the AAP resources like project, inventory, host, job template.

```bash
ansible-playbook -e @extra_vars.yml playbook.yml
```

Step 5: Configure HCP Terraform credentials. Refer to the [tfe_provider authentication docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication) for the various token options and guidance. For example:

```bash
export TFE_TOKEN=example
```

Step 6: In the [tf/03-tf-workspaces/](./tf/03-tf-workspaces/) directory, copy [tf/03-tf-workspaces/terraform.tfvars.example](./tf/03-tf-workspaces/terraform.tfvars.example) to `terraform.tfvars` and change the variables accordingly.

Step 7: In the [tf/03-tf-workspaces/](./tf/03-tf-workspaces/) directory, run an apply, review the plan output, and approve the plan accordingly.

```bash
terraform init
terraform apply
```

# 3. Verify

## 3.1 GitHub repo for Ansible playbook

GitHub repo contains the [conditional-playbook.yml](./tf/01-tf-github-repo-playbook/tf-github-bootstrap/conditional-playbook.yml) that fails if `var_from_tf_aap_job_launch` has a value of `fail`

![github playbook repo](./docs/02-deployment/01-github-playbook/01-github-playbook-repo.png)

## 3.2 AAP

### 3.2.1 AAP Project

AAP Project details links to the GitHub repo that contains the playbook.

![project details](./docs/02-deployment/02-aap/01-project/01-project-details.png)

Project linked to the job template. This job template references the created `localhost-inventory`.

![project job templates](./docs/02-deployment/02-aap/01-project/02-project-job-templates.png)

### 3.2.2 AAP Inventory

Inventory details shows 1 host.

![inventory details](./docs/02-deployment/02-aap/02-inventory/01-inventory-details.png)

Inventory contains a single `localhost` host.

![inventory hosts](./docs/02-deployment/02-aap/02-inventory/02-inventory-hosts.png)

### 3.2.3 AAP Job template

Job template details shows the configuration with the linked project and inventory.

![job template details](./docs/02-deployment/02-aap/03-job-template/01-job-template-details.png)

## 3.3 GitHub workspace repo

GitHub repo contains the Terraform configuration for the workspaces. It expects 2 variables that determine the terraform action behavior and the playbook outcome.

- `var_from_tf_aap_job_launch`: Determines if the playbook will run successfully or result in an error.
- `aap_job_launch_wait_for_completion`: Determines if the action should wait for the `aap_job_launch` action should wait for the playbook result

![github workspace repo](./docs/02-deployment/03-github-workspace/01-github-workspace-repo.png)

## 3.4 HCP Terraform

### 3.4.1 HCP Terraform Project

Project contains the 4 workspaces with different permutations of `wait_for_completion` and success values.

![project workspaces](./docs/02-deployment/04-tf/01-project/01-project-workspaces.png)

Project has a variable set that contains the AAP credentials.

![project variable sets](./docs/02-deployment/04-tf/01-project/02-project-variable-sets.png)

Variable set contains the AAP environment variables required for authentication.

![variable set variables](./docs/02-deployment/04-tf/01-project/03-variable-set-variables.png)

### 3.4.2 HCP Terraform Workspace - action-wait-success

Workspace overview shows the VCS connection to the GitHub repository.

![workspace overview](./docs/02-deployment/04-tf/02-workspace-action-wait-success/01-workspace-overview.png)

Workspace variables show `aap_job_launch_wait_for_completion=true` and `var_from_tf_aap_job_launch=success`.

![workspace variables](./docs/02-deployment/04-tf/02-workspace-action-wait-success/02-workspace-variables.png)

### 3.4.3 HCP Terraform Workspace - action-wait-fail

Workspace overview shows the VCS connection to the GitHub repository.

![workspace overview](./docs/02-deployment/04-tf/03-workspace-action-wait-fail/01-workspace-overview.png)

Workspace variables show `aap_job_launch_wait_for_completion=true` and `var_from_tf_aap_job_launch=fail`.

![workspace variables](./docs/02-deployment/04-tf/03-workspace-action-wait-fail/02-workspace-variables.png)

### 3.4.4 HCP Terraform Workspace - action-no-wait-success

Workspace overview shows the VCS connection to the GitHub repository.

![workspace overview](./docs/02-deployment/04-tf/04-workspace-action-no-wait-success/01-workspace-overview.png)

Workspace variables show `aap_job_launch_wait_for_completion=false` and `var_from_tf_aap_job_launch=success`.

![workspace variables](./docs/02-deployment/04-tf/04-workspace-action-no-wait-success/02-workspace-variables.png)

### 3.4.5 HCP Terraform Workspace - action-no-wait-fail

Workspace overview shows the VCS connection to the GitHub repository.

![workspace overview](./docs/02-deployment/04-tf/05-workspace-action-no-wait-fail/01-workspace-overview.png)

Workspace variables show `aap_job_launch_wait_for_completion=false` and `var_from_tf_aap_job_launch=fail`.

![workspace variables](./docs/02-deployment/04-tf/05-workspace-action-no-wait-fail/02-workspace-variables.png)

# 4. Testing

## 4.1 Action wait success

Workspace plan shows the Terraform plan before applying. This shows 1 action to invoke. Choose `Confirm & apply`.

![workspace plan](./docs/03-testing/01-action-wait-success/01-workspace-plan.png)

Terraform apply running. This also shows the action `Starting`.

![apply running](./docs/03-testing/01-action-wait-success/02-apply-running.png)

Playbook running shows the AAP job execution in progress.

![playbook running](./docs/03-testing/01-action-wait-success/03-playbook-running.png)

Playbook success output shows the successful execution output.

![playbook success output](./docs/03-testing/01-action-wait-success/04-playbook-success-output.png)

Playbook success details shows the job details after successful completion. This has `var_from_tf_aap_job_launch: success`.

![playbook success details](./docs/03-testing/01-action-wait-success/05-playbook-success-details.png)

Apply finished and this shows the Terraform action as `Invoked`.

![apply finished](./docs/03-testing/01-action-wait-success/06-apply-finished.png)

## 4.2 Action wait fail

Workspace plan shows the Terraform plan before applying. This shows 1 action to invoke. Choose `Confirm & apply`.

![workspace plan](./docs/03-testing/02-action-wait-fail/01-workspace-plan.png)

Terraform apply running. This also shows the action `Starting`.

![apply running](./docs/03-testing/02-action-wait-fail/02-apply-running.png)

Playbook running shows the AAP job execution in progress.

![playbook running](./docs/03-testing/02-action-wait-fail/03-playbook-running.png)

Playbook failed output shows the failed execution output.

![playbook failed output](./docs/03-testing/02-action-wait-fail/04-playbook-failed-output.png)

Playbook failed details shows the job details after failed completion. This has `var_from_tf_aap_job_launch: fail`.

![playbook failed details](./docs/03-testing/02-action-wait-fail/05-playbook-failed-details.png)

Apply finished and this shows the Terraform action as `Errored`. This provides a the ID of the failed AAP Job but does not show the failure message.

![apply finished](./docs/03-testing/02-action-wait-fail/06-apply-finished.png)

## 4.3 Action no wait success

Workspace plan shows the Terraform plan before applying. This shows 1 action to invoke. Choose `Confirm & apply`.

![workspace plan](./docs/03-testing/03-action-no-wait-success/01-workspace-plan.png)

Apply finished shows the Terraform apply completed, with the action `Invoked`, without waiting for the playbook to complete.

![apply finished](./docs/03-testing/03-action-no-wait-success/02-apply-finished.png)

Playbook running shows the AAP job execution in progress after Terraform apply completed.

![playbook running](./docs/03-testing/03-action-no-wait-success/04-playbook-running.png)

Playbook success output shows the successful execution output.

![playbook success output](./docs/03-testing/03-action-no-wait-success/05-playbook-success-output.png)

Playbook success details shows the job details after successful completion. This has `var_from_tf_aap_job_launch: success`.

![playbook success details](./docs/03-testing/03-action-no-wait-success/06-playbook-success-details.png)

## 4.4 Action no wait fail

Workspace plan shows the Terraform plan before applying. This shows 1 action to invoke. Choose `Confirm & apply`.

![workspace plan](./docs/03-testing/04-action-no-wait-fail/01-workspace-plan.png)

Apply finished shows the Terraform apply completed, with the action `Invoked`, without waiting for the playbook to complete.

![apply finished](./docs/03-testing/04-action-no-wait-fail/02-apply-finished.png)

Playbook running shows the AAP job execution in progress even after Terraform apply completed.

![playbook running](./docs/03-testing/04-action-no-wait-fail/04-playbook-running.png)

After some time, the playbook fails and shows the failed execution output.

![playbook failed output](./docs/03-testing/04-action-no-wait-fail/05-playbook-failed-output.png)

Playbook failed details shows the job details after failed completion. This has `var_from_tf_aap_job_launch: fail`.

![playbook failed details](./docs/03-testing/04-action-no-wait-fail/06-playbook-failed-details.png)

Even refreshing the Terraform workspace shows that the apply finished and that the run was successful.

![apply finished](./docs/03-testing/04-action-no-wait-fail/07-apply-finished.png)

Workspace overview shows the run as successful since Terraform did not wait for the playbook completion.

![workspace overview](./docs/03-testing/04-action-no-wait-fail/08-workspace-overview.png)

# 5. Cleanup

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: In [tf/04-ansible-playbook-cleanup](./tf/04-ansible-playbook-cleanup/) run

```bash
ansible-playbook -e playbook.yml
```