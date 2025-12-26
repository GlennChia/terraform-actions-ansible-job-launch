resource "tfe_project" "tf_actions_aap" {
  organization = var.tf_organization_name
  name         = "tf-actions-aap"
}

resource "tfe_variable_set" "aap_credentials" {
  name         = "AAP credential variable set"
  description  = "AAP credential variable set with host, username, password"
  organization = var.tf_organization_name
}

resource "tfe_variable" "aap_hostname" {
  key             = "AAP_HOSTNAME"
  value           = var.aap_hostname
  category        = "env"
  description     = "AAP Server URL"
  variable_set_id = tfe_variable_set.aap_credentials.id
}

resource "tfe_variable" "aap_username" {
  key             = "AAP_USERNAME"
  value           = var.aap_username
  category        = "env"
  description     = "Username to use for basic authentication"
  variable_set_id = tfe_variable_set.aap_credentials.id
  sensitive       = true
}

resource "tfe_variable" "aap_password" {
  key             = "AAP_PASSWORD"
  value           = var.aap_password
  category        = "env"
  description     = "Password to use for basic authentication"
  variable_set_id = tfe_variable_set.aap_credentials.id
  sensitive       = true
}

resource "tfe_project_variable_set" "tf_actions_aap_and_aap_credentials" {
  project_id      = tfe_project.tf_actions_aap.id
  variable_set_id = tfe_variable_set.aap_credentials.id
}
