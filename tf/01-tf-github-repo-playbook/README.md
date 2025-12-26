# Create a GitHub repo containing the Ansible Playbook

Step 1: In the [tf/01-tf-github-repo-playbook/](./tf/01-tf-github-repo-playbook/) directory, copy [tf/test-auto-scaling/terraform.tfvars.example](./tf/01-tf-github-repo-playbook/terraform.tfvars.example) to `terraform.tfvars` and change the environment variables accordingly. GitHub credentials can use a [personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens). This token needs sufficient permissions to create, delete repositories, and write files to the repository.

Step 2: Run an apply, review the plan output, and approve the plan accordingly. The apply outputs the GitHub repository's HTML URL. This is used for `scm_url` in [02-ansible-playbook-create/extra_vars.yml](../02-ansible-playbook-create/extra_vars.yml)

> [!CAUTION]
> In a live environment, it is not good practice to directly pass the GitHub token. Instead, sensitive credentials should be securely stored and accessed using solutions like HashiCorp Vault, which provides encrypted storage and access controls capabilities.

```bash
terraform init
terraform apply
```