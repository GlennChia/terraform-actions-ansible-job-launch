locals {
  github_branch              = "main"
  terraform_fqdn_no_protocol = split("//", var.terraform_url)[1]
}
