# Create a HCP Terraform Project that contains the 4 test workspaces

Step 1: Configure HCP Terraform credentials. Refer to the [tfe_provider authentication docs](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs#authentication) for the various token options and guidance. For example:

```bash
export TFE_TOKEN=example
```

Step 2: Run an apply, review the plan output, and approve the plan accordingly.

```bash
terraform init
terraform apply
```