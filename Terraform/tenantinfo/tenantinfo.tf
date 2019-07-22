resource "null_resource" "tenant" {
    triggers = {
        build_number = "${timestamp()}"
    }
    provisioner "local-exec" {
        command = <<EOF
      az account show --query tenantId -o tsv > tenantid.txt
EOF
  }
}

output "tenant_id" {
    value = "${trimspace(fileexists("tenantid.txt") ? file("tenantid.txt") : "NOT ININTIALIZED") }"
    depends_on = ["null_resource.tenant"]
}