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

variable "AADAdminUser" {
    default = ""
}

variable "AADAdminGroup" {
    default = ""
}

variable "admin_username" {
    default = "sysuser01"
}
variable "kubernetes_version" {
    default = "1.13.7"
}

variable "agent_pool_config" {
  # type = list(object({
  #  name            = string
  #  count           = number
  #  vm_size         = string 
  #  os_type         = string   
  #  os_disk_size_gb = number
  #  max_pods        = number
  #  type            = string
  #  vnet_subnet_id  = string
  #}))
  default = [
    {
      name = "agentpool",
      count = 1,
      vm_size = "Standard_B2s",
      os_type = "Linux",
      os_disk_size_gb = 30,
      max_pods = 50,
      type = "AvailabilitySet",
      vnet_subnet_id = null,
    },
  ]
}