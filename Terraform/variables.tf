variable "client_id" {
    default = ""
    }
variable "client_secret" {
    default = ""
    }
variable "tenant_id" {
    default = ""
    }    
variable "rbac_server_app_id" {
    default = ""
}
variable "rbac_server_app_secret" {
    default = ""
}
variable "rbac_client_app_id" {
    default = ""
    }

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

variable "admin_username" {
    default = "sysuser01"
}
variable "kubernetes_version" {
    default = "1.11.5"
}