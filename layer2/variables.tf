variable "app" {
  description = "Application that we want to deploy"
  type        = string
  default     = "ghrunner"
}

variable "env" {
  description = "Application env"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Location short name "
  type        = string
  default     = "we"
}

variable "container_image" {
  description = "container image name"
  type        = string
  default     = "ghrunner"
}

variable "container_tag" {
  description = "semver tag of container image"
  type        = string
  default     = "0.0.1"
}

variable "github_token" {
  description = "github used for registering runner"
  sensitive   = true
  type        = string
}

variable "github_repo" {
  description = "github repository"
  type        = string
  default     = "gh-runners-aca"
}

variable "github_org" {
  description = "github organization"
  type        = string
  default     = "crytlig"
}


locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = "cry"
    app         = var.app
  }
}
