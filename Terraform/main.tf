provider "azurerm" {
    version = "~>1.5"
}

terraform {
    backend "azurerm" {
    }
}

module "tenantinfo" {
    source = "./tenantinfo"    
}

output "tenantid" {
    value = "${module.tenantinfo.tenantid}"
}