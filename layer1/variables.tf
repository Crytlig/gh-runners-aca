variable "region" {
  description = "Azure infrastructure region"
  type    = string
  default = "westeurope"
}

variable "app" {
  description = "Application that we want to deploy"
  type    = string
  default = "ghrunner"
}

variable "env" {
  description = "Application env"
  type    = string
  default = "dev"
}

variable "location" {
  description = "Location short name "
  type    = string
  default = "we"
}

locals {
  stack = "${var.app}-${var.env}-${var.location}"

  default_tags = {
    environment = var.env
    owner       = "cry"
    app         = var.app
  }
}