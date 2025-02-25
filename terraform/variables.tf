variable "project" {
  type = string
  description = "Project name"
  default = "tilbudmagi"
}

variable "environment" {
  type = string
  description = "Environment (dev / stage / prod)"
  default = "dev"
}

variable "location" {
  type = string
  description = "Azure region to deploy module to"
  default = "North Europe"
}