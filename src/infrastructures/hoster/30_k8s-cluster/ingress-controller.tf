
resource "kubernetes_namespace" "ingress_nginx" {
  depends_on = [
    rke_cluster.kube_coreos
  ]
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.1.0"

  namespace  = kubernetes_namespace.ingress_nginx.metadata.0.name

  set {
    name  = "controller.service.enabled"
    value = "false"
  }

  set {
    name  = "controller.hostPort.enabled"
    value = "true"
  }

  set {
    name  = "controller.hostPort.ports.http"
    value = "80"
  }

  set {
    name  = "controller.hostPort.ports.https"
    value = "443"
  }

  // set {
  //   name  = "controller.metrics.serviceMonitor.enabled"
  //   value = "true"
  // }

  // set {
  //   name  = "controller.metrics.serviceMonitor.additionalLabels.release"
  //   value = "prometheus"
  // }

}
