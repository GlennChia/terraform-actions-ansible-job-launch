resource "tfe_workspace" "action_no_wait_fail" {
  name              = "action-no-wait-fail"
  organization      = var.tf_organization_name
  queue_all_runs    = false
  project_id        = tfe_project.tf_actions_aap.id
  force_delete      = true
  terraform_version = "1.14.3"

  vcs_repo {
    branch         = local.github_branch
    identifier     = github_repository.tf_workspace.full_name
    oauth_token_id = tfe_oauth_client.github.oauth_token_id
  }
}

resource "tfe_variable" "action_no_wait_fail_var_from_tf_aap_job_launch" {
  key          = "var_from_tf_aap_job_launch"
  value        = "fail"
  category     = "terraform"
  workspace_id = tfe_workspace.action_no_wait_fail.id
}

resource "tfe_variable" "action_no_wait_fail_aap_job_launch_wait_for_completion" {
  key          = "aap_job_launch_wait_for_completion"
  value        = false
  category     = "terraform"
  workspace_id = tfe_workspace.action_no_wait_fail.id
}
