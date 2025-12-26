variable "region" {
  description = "Region to deploy resources into"
  type        = string
  default     = "us-east-1"
}

variable "tf_organization_name" {
  description = "Terraform Organization name to deploy resources to."
  type        = string
}

variable "github_token" {
  description = "A GitHub OAuth / Personal Access Token. When not provided or made available via the GITHUB_TOKEN environment variable, the provider can only access resources available anonymously"
  type        = string
  sensitive   = true
}

variable "terraform_url" {
  type        = string
  description = "Terraform Cloud URL or Terraform Enterprise FQDN"
  default     = "https://app.terraform.io"
}

variable "aap_hostname" {
  description = "AAP host to connect the provider to"
  type        = string
}

variable "aap_username" {
  description = "AAP host username to connect the provider to"
  type        = string
  sensitive   = true
}

variable "aap_password" {
  description = "AAP host password to connect the provider to"
  type        = string
  sensitive   = true
}
