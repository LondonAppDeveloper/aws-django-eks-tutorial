
variable "region" {
  description = "AWS region to deploy resources to"
  default     = "eu-west-2"
}

variable "prefix" {
  description = "Prefix to be assigned to resources."
  default     = "django-k8s"
}

variable "db_password" {
  description = "Password for the RDS database instance."
  default     = "samplepassword123"
}
