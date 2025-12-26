# Ansible playbook to cleanup

Step 1: Configure AAP credentials. For example

```bash
export CONTROLLER_HOST="replace"
export CONTROLLER_USERNAME="replace"
export CONTROLLER_PASSWORD=replace
```

Step 2: Run the following to delete the AAP resources like project, inventory, host, job template.

```bash
ansible-playbook playbook.yml
```
