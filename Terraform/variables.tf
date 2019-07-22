variable "prefix" {
  default = ""
}

variable "env" {
  default = "dev"
}

variable "location" {
  default     = "North Europe"
  description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "public_ssh_key_path" {
  description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
  default     = "~/.ssh/id_rsa.pub"
}