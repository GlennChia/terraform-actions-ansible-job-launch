# Ansible playbook to configure AAP resources

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: In [extra_vars.yml](./extra_vars.yml) replace the `scm_url` with the URL to the GitHub repository that has the Ansible playbook. Then run the following to setup the AAP resources like project, inventory, host, job template.

```bash
ansible-playbook -e @extra_vars.yml playbook.yml
```
