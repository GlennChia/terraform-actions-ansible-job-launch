resource "github_repository" "ansible_playbook" {
  name        = "tf-action-aap-job-launch-playbook"
  description = "repo created with a playbook that conditional succeeds to configure nginx or fails"
  auto_init   = true
  visibility  = "public"
}

resource "github_repository_file" "ansible_playbook" {
  repository          = github_repository.ansible_playbook.name
  branch              = "main"
  commit_message      = "feat: conditional success/fail playbook"
  overwrite_on_create = true
  file                = "conditional-playbook.yml"
  content             = file("./tf-github-bootstrap/conditional-playbook.yml")
}
