variable "aws_provider_main_region" {
  description = "Region of deployment"
  type        = string
}

variable "aws_credentials_profile" {
  description = "Profile name with the credentials to run. profiles usually are found at ~/.aws/credentials"
  type        = string
}

variable "public_key" {
  description = "Create aws ssh key pair out of a public key"
  type        = string
}

variable "private_key_name" {
  description = "The private key name to connect with"
  type        = string
  default     = "compromised_key"
}