##################################################################################
# HELM RESOURCES
##################################################################################

provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.main.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name      = "terraform-tiller"
    namespace = "kube-system"
  }

  automount_service_account_token = true

  depends_on = ["azurerm_kubernetes_cluster.main"]
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "terraform-tiller"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "cluster-admin"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "terraform-tiller"
    namespace = "kube-system"
  }

  depends_on = ["azurerm_kubernetes_cluster.main"]
}

provider "helm" {
  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.main.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)}"
  }

  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  namespace       = "${kubernetes_service_account.tiller.metadata.0.namespace}"
  install_tiller  = true
}

resource "helm_release" "nginx" {
  name      = "nginx"
  chart     = "stable/nginx-ingress"
  namespace = "ingress"

  depends_on = ["kubernetes_service_account.tiller","kubernetes_cluster_role_binding.tiller"]
}

resource "helm_release" "prometheus" {
  name      = "prometheus"
  chart     = "stable/prometheus "
  namespace = "monitoring"

  depends_on = ["kubernetes_service_account.tiller","kubernetes_cluster_role_binding.tiller"]
}

data "kubernetes_service" "ingress_services" {
  metadata {
    name      = "nginx-nginx-ingress-controller"
    namespace = "${helm_release.nginx.namespace}"
  }
  
  depends_on = ["helm_release.nginx"]
}

resource "helm_release" "weavescope" {
  name  = "weavescope"
  chart = "stable/weave-scope "

  namespace = "monitoring"
}

locals {
  weavescope_dns = "monitor.${data.kubernetes_service.ingress_services.load_balancer_ingress.0.ip}.nip.io"
}

resource "kubernetes_ingress" "weavescope_ingress" {
  depends_on = ["helm_release.nginx"]

  metadata {
    name      = "weavescope-ingress"
    namespace = "monitoring"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rule {
      host = local.weavescope_dns
      http {
        path {
          backend {
            service_name = "weavescope-weave-scope"
            service_port = "http"
          }
        }
      }
    }
  }
}

output "weavescope_dns" {
  value = local.weavescope_dns
}