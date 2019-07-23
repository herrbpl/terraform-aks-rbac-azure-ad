provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.k8s.kube_admin_config.0.host}"
  #username               = "${azurerm_kubernetes_cluster.k8s.kube_admin_config.0.username}"
  #password               = "${azurerm_kubernetes_cluster.k8s.kube_admin_config.0.password}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.k8s.kube_admin_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_cluster_role_binding" "setadminuser" {
    count = "${var.AADAdminUser == "" ? 0 : 1}"
    metadata {
        name        = "terracreated-clusteradminrole-binding-user"
    }
    role_ref {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "ClusterRole"
        name        = "cluster-admin"
    }
    subject {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "User"
        name        = "${var.AADAdminUser}"
    } 
    depends_on = ["azurerm_kubernetes_cluster.k8s"]
}

resource "kubernetes_cluster_role_binding" "setadmingroup" {
    count = "${var.AADAdminGroup == "" ? 0 : 1}"
    metadata {
        name        = "terracreated-clusteradminrole-binding-user"
    }
    role_ref {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "ClusterRole"
        name        = "cluster-admin"
    }
    subject {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "Group"
        name        = "${var.AADAdminGroup}"
    } 
    depends_on = ["azurerm_kubernetes_cluster.k8s"]
}

resource "kubernetes_cluster_role_binding" "dashboard" {
    count = "${var.EnableDashboard == "true" ? 1 : 0}"
    metadata {
        name        = "terracreated-clusteradminrole-dashboard-access"
    }
    role_ref {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "ClusterRole"
        name        = "cluster-admin"
    }
    subject {        
        kind        = "ServiceAccount"
        name        = "kubernetes-dashboard"
        namespace   = "kube-system"
    } 
    depends_on = ["azurerm_kubernetes_cluster.k8s"]
}