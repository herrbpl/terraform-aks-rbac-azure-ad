resource "kubernetes_service_account" "tiller" {
    count = "${var.EnableGlobalTiller  ? 1 : 0}"
    metadata {
        name = "tiller-system"
        namespace = "kube-system"  
    }
 
}

resource "kubernetes_cluster_role_binding" "tiller" {
    count = "${var.EnableGlobalTiller  ? 1 : 0}"
    metadata {
        name        = "terracreated-clusteradminrole-global-tiller"
    }
    role_ref {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "ClusterRole"
        name        = "cluster-admin"
    }
    subject {        
        kind        = "ServiceAccount"
        name        = "tiller-system"
        namespace   = "kube-system"
    } 
    depends_on = ["azurerm_kubernetes_cluster.k8s","kubernetes_service_account.tiller" ]
}