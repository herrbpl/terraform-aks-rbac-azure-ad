provider "azurerm" {
    version = "~>1.5"
}

terraform {
    backend "azurerm" {
    }
}

module "rbac" {
    source = "./rbac"
}

module "kubernetes" {
  source = "./kubernetes"
  public_ssh_key_path = "C:/Users/siim/OneDrive - GT Tarkvara/Passwords/SSH Keys/GT SSH Key/gt-ssh-public"
  client_id = "${module.rbac.client_application_id}"
  client_secret = "${module.rbac.client_application_secret}"
  rbac_server_app_id = "${module.rbac.server_application_id}"
  rbac_server_app_secret = "${module.rbac.server_application_secret}"
  rbac_client_app_id = "${module.rbac.client_application_id}"
}
