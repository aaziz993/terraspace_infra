# This is where you put your resource declaration
resource "kubernetes_namespace" "spire-server" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "kubernetes_stateful_set_v1" "spire-server" {
  metadata {
    namespace = var.namespace.create ? kubernetes_namespace.spire-server.0.id : var.namespace.metadata.name
    name      = var.name
    labels    = {
      app = var.name
    }
  }
  spec {
    service_name = var.name
    replicas     = var.replicas
    selector {
      match_labels = {
        app = var.name
      }
    }
    template {
      metadata {
        labels = {
          app = var.name
        }
      }
      spec {
        container {
          args = [
            "-config",
            "/run/spire/config/server.conf",
          ]
          image = "${var.hub}:${var.tag}"
          liveness_probe {
            failure_threshold = 2
            http_get {
              path = "/live"
              port = 8080
            }
            initial_delay_seconds = 15
            period_seconds        = 60
            timeout_seconds       = 3
          }
          name = "spire-server"
          port {
            container_port = var.bind.port
          }
          readiness_probe {
            http_get {
              path = "/ready"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
          volume_mount {
            mount_path = "/run/spire/config"
            name       = "spire-config"
            read_only  = true
          }
          volume_mount {
            mount_path = "/run/spire/data"
            name       = "spire-data"
            read_only  = false
          }
          volume_mount {
            mount_path = "/run/spire/sockets"
            name       = "spire-registration-socket"
            read_only  = false
          }
        }
        container {
          args = [
            "-config",
            "/run/spire/config/k8s-workload-registrar.conf",
          ]
          image = "${var.k8s_workload_registrar.hub}:${var.k8s_workload_registrar.tag}"
          name  = "k8s-workload-registrar"
          port {
            container_port = 9443
            name           = "webhook"
            protocol       = "TCP"
          }
          volume_mount {
            mount_path = "/run/spire/config"
            name       = "k8s-workload-registrar-config"
            read_only  = true
          }
          volume_mount {
            mount_path = "/run/spire/sockets"
            name       = "spire-registration-socket"
            read_only  = true
          }
        }
        service_account_name    = kubernetes_service_account_v1.spire-server.metadata.0.name
        share_process_namespace = true
        volume {
          config_map {
            name = kubernetes_config_map_v1.spire-server.metadata.0.name
          }
          name = "spire-config"
        }
        volume {
          config_map {
            name = kubernetes_config_map_v1.k8s-workload-registrar.metadata.0.name
          }
          name = "k8s-workload-registrar-config"
        }
        volume {
          host_path {
            path = "/run/spire/server-sockets"
            type = "DirectoryOrCreate"
          }
          name = "spire-registration-socket"
        }
      }
    }
    volume_claim_template {
      metadata {
        name      = "spire-data"
        namespace = var.namespace.create ? kubernetes_namespace.spire-server.0.id : var.namespace.metadata.name
      }
      spec {
        access_modes = [
          "ReadWriteOnce",
        ]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_service_account_v1.spire-server, kubernetes_config_map_v1.k8s-workload-registrar]
}

resource "kubernetes_service_v1" "spire-server" {
  metadata {
    namespace = var.namespace.create ? kubernetes_namespace.spire-server.0.id : var.namespace.metadata.name
    name      = var.name
  }
  spec {
    selector = {
      app = var.name
    }
    type = "NodePort"
    port {
      name        = "grpc"
      port        = var.bind.port
      protocol    = "TCP"
      target_port = var.bind.port
    }
  }
  depends_on = [kubernetes_namespace.spire-server]
}