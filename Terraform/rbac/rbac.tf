# Damnnit, Azure CLI SDK has issue which actually prevents correct RBAC secret generation. Like what the hell?
# https://github.com/Azure/azure-sdk-for-go/issues/5222


locals {
  env = "${var.env == "" ? "dev" : var.env}"  
  name = "${var.name == "" ? "app" : var.name}"  
  appname_server    = "${var.prefix}${local.env}-${local.name}-rbac-server"
  appname_client    = "${var.prefix}${local.env}-${local.name}-rbac-client"
  end_date = "${var.end_date == "" ? timeadd(timestamp(), "720h") : var.end_date }"
  
}

# Create server app
resource "azuread_application" "server" {
  name                       = "${local.appname_server}"
  homepage                   = "https://${local.appname_server}"
  identifier_uris            = ["https://${local.appname_server}"]
  reply_urls                 = ["https://${local.appname_server}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = false
  type                       = "webapp/api"

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000"

    resource_access {
      id = "7ab1d382-f21e-4acd-a863-ba3e13f7da61"
      type = "Role"
    }
    resource_access {
      id = "06da0dbc-49e2-44d2-8312-53f166ab848a"
      type = "Scope"
    }

    resource_access {
      id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = "00000002-0000-0000-c000-000000000000"

    resource_access {
      id = "311a71cc-e848-46a1-bdf8-97ff7156d8e6"
      type = "Scope"
    }
  }
  provisioner "local-exec" {
       command = "Start-Sleep -Seconds 30"
        interpreter = ["PowerShell", "-Command"]
  }
}

# update server manifest group membership claims
resource "null_resource" "server_manifest" {
    triggers = {
        key = "${azuread_application.server.application_id}"
    }
    provisioner "local-exec" {
      command = <<EOF
        az ad app update --id ${azuread_application.server.application_id} --set groupMembershipClaims=All
EOF
    }
}

# create service principal for app
resource "azuread_service_principal" "server" {
    application_id = "${azuread_application.server.application_id}"
}

# create password for server app
resource "random_string" "server" {
  length  = 16
  special = true
  override_special = "!.="
  keepers = {
    service_principal = "${azuread_service_principal.server.id}"
  }
}


resource "azuread_service_principal_password" "server" {
    service_principal_id = "${azuread_service_principal.server.id}"
    value                = "${random_string.server.result}"    
    end_date             = "${local.end_date}"
    lifecycle {
        ignore_changes = ["end_date"]
    }
    
}

resource "null_resource" "server_password" {
    triggers = {
      application_id = "${azuread_application.server.application_id}"
    }
    provisioner "local-exec" {
      command = <<EOF
az ad sp credential reset --name ${azuread_application.server.name} --end-date ${local.end_date} --password  ${random_string.server.result}    
EOF
    }
    depends_on = ["azuread_application.server", "azuread_service_principal.server","random_string.server"]
    
}


# grant permissions for server app
resource "null_resource" "server_grants" {
    triggers = {
      oauth2_permissions = "${join(",", azuread_application.server.required_resource_access.*.resource_app_id)}"
    }
    provisioner "local-exec" {
      command = <<EOF
        %{ for permission in azuread_application.server.required_resource_access.* ~}
az ad app permission grant --id ${azuread_application.server.application_id} --api ${permission.resource_app_id} 
%{ endfor ~}
EOF
    }
    depends_on = ["azuread_application.server", "azuread_service_principal_password.server"]
    
}

# client application

resource "azuread_application" "client" {
  name                       = "${local.appname_client}"
  homepage                   = "https://${local.appname_client}"
  reply_urls                 = ["https://${local.appname_client}"]
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = true
  type                       = "native"

  required_resource_access {
    resource_app_id = "${azuread_application.server.application_id}"

    resource_access {
      id = "${azuread_application.server.oauth2_permissions.0.id}"
      type = "Scope"
    }

  }
  provisioner "local-exec" {
       command = "Start-Sleep -Seconds 30"
        interpreter = ["PowerShell", "-Command"]
  }

}

resource "azuread_service_principal" "client" {
    application_id = "${azuread_application.client.application_id}"
}

resource "random_string" "client" {
  length  = 16
  special = true
  override_special = "!.="
  keepers = {
    service_principal = "${azuread_service_principal.client.id}"
  }
}
resource "azuread_service_principal_password" "client" {
    service_principal_id = "${azuread_service_principal.client.id}"
    value                = "${random_string.client.result}"    
    end_date             = "${local.end_date}"
    lifecycle {
        ignore_changes = ["end_date"]
    } 
}

resource "null_resource" "client_password" {
    triggers = {
      application_id = "${azuread_application.client.application_id}"
    }
    provisioner "local-exec" {
      command = <<EOF
az ad sp credential reset --name ${azuread_application.client.name} --end-date ${local.end_date} --password  ${random_string.client.result}    
EOF
    }
    depends_on = ["azuread_application.client", "azuread_service_principal.client","random_string.client"]
    
}



# grant permissions for client app
resource "null_resource" "client_grants" {
    triggers = {
      oauth2_permissions = "${join(",", azuread_application.client.required_resource_access.*.resource_app_id)}"
    }
    provisioner "local-exec" {
      command = <<EOF
        %{ for permission in azuread_application.client.required_resource_access.* ~}
az ad app permission grant --id ${azuread_application.client.application_id} --api ${permission.resource_app_id} 
%{ endfor ~}
EOF
    }
    depends_on = ["azuread_application.client", "azuread_service_principal_password.client"]
    
}