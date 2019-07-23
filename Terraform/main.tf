provider "azurerm" {
    version = "~>1.5"
}

terraform {
    backend "azurerm" {
    }
}

module "rbac" {
    source = "./rbac"
    prefix = "elk"
    env = "dev"
}

module "kubernetes" {
    source = "./kubernetes"
    public_ssh_key_path = "C:/Users/siim/OneDrive - GT Tarkvara/Passwords/SSH Keys/GT SSH Key/id_rsa_gt.pub"
    client_id = "${module.rbac.client_application_id}"
    client_secret = "${module.rbac.client_application_secret}"
    rbac_server_app_id = "${module.rbac.server_application_id}"
    rbac_server_app_secret = "${module.rbac.server_application_secret}"
    rbac_client_app_id = "${module.rbac.client_application_id}"
    agent_pool_config = [ {
        name = "agentpool",
        count = 3,
        type = "VirtualMachineScaleSets",
        vm_size = "Standard_D2s_v3"
    }
    ]
    AADAdminGroup = "d1237dd7-0369-4a32-a258-5f3d587620d7"
    EnableDashboard = true
    EnableGlobalTiller = true
    prefix = "elk"
    env = "dev"
}

output "kube_admin_config_raw" {
    value = "${module.kubernetes.kube_admin_config_raw}"
}

output "kube_config_raw" {
    value = "${module.kubernetes.kube_config_raw}"
}