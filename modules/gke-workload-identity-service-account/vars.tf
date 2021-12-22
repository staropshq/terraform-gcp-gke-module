variable "project_id" {
  type = string

}

variable "service_account_name" {
  type = string
}

variable "namespace" {
  type = string
  default = "default"
  description = "Which K8S namespace the application is deployed to to properly use the SA."
}

variable "service_account_roles" {
  type = list(string)
  description = "The Project IAM roles to apply to the Service Account"

}