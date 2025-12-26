resource "github_repository" "tf_workspace" {
  name        = "tf-action-aap-job-launch-workspace"
  description = "repo created with a workspace that has a terraform action for AAP Job Launch"
  auto_init   = true
  visibility  = "public"
}

resource "github_repository_file" "main_tf" {
  repository          = github_repository.tf_workspace.name
  branch              = "main"
  commit_message      = "feat: terraform resources with action"
  overwrite_on_create = true
  file                = "main.tf"
  content             = file("./tf-github-bootstrap/main.tf")
}
