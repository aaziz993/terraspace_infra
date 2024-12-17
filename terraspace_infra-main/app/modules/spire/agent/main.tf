# This is where you put your resource declaration


resource "kubernetes_namespace" "spire-agent" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "kubernetes_service_account_v1" "spire-agent" {
  metadata {
    name      = "spire-agent"
    namespace = var.namespace.create ? kubernetes_namespace.spire-agent.0.id : var.namespace.metadata.name
  }
  depends_on = [kubernetes_namespace.spire-agent]
}

resource "kubernetes_cluster_role_v1" "spire-agent" {
  metadata {
    name = "spire-agent-cluster-role"
  }
  rule {
    api_groups = [""]
    resources  = ["pods", "nodes", "nodes/proxy"]
    verbs      = ["get"]
  }
}

resource "kubernetes_cluster_role_binding_v1" "spire-agent" {
  metadata {
    name = "spire-agent-cluster-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role_v1.spire-agent.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.spire-agent.metadata.0.name
    namespace = kubernetes_service_account_v1.spire-agent.metadata.0.namespace
  }
  depends_on = [kubernetes_service_account_v1.spire-agent, kubernetes_cluster_role_v1.spire-agent]
}

resource "kubernetes_config_map_v1" "spire-agent" {
  metadata {
    name      = "spire-agent"
    namespace = var.namespace.create ? kubernetes_namespace.spire-agent.0.id : var.namespace.metadata.name
  }
  data = {
    "agent.conf" = <<-EOT
      agent {
        data_dir = "/run/spire"
        log_level = "${var.log_level}"
        server_address = "${var.spire_server.address}"
        server_port = "${var.spire_server.port}"
        socket_path = "${var.socket_path}"
        trust_bundle_path = "/run/spire/bundle/root-cert.pem"
        trust_domain = "${var.trust_domain}"
      }
      plugins {
        NodeAttestor "k8s_psat" {
          plugin_data {
            cluster = "${var.cluster_name}"
          }
        }
        KeyManager "memory" {
          plugin_data {
          }
        }
        WorkloadAttestor "k8s" {
          plugin_data {
            # Defaults to the secure kubelet port by default.
            # Minikube does not have a cert in the cluster CA bundle that
            # can authenticate the kubelet cert, so skip validation.
            skip_kubelet_verification = true
          }
        }
        WorkloadAttestor "unix" {
            plugin_data {
            }
        }

        %{ for plugin in var.plugins}
          ${plugin}
        %{ endfor }
      }
      health_checks {
        listener_enabled = true
        bind_address = "0.0.0.0"
        bind_port = "8080"
        live_path = "/live"
        ready_path = "/ready"
      }
      EOT
  }
  depends_on = [kubernetes_namespace.spire-agent]
}

resource "kubernetes_daemon_set_v1" "spire-agent" {
  metadata {
    namespace = var.namespace.create ? kubernetes_namespace.spire-agent.0.id : var.namespace.metadata.name
    name      = var.name
    labels    = {
      app = var.name
    }
  }
  spec {
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
            "/run/spire/config/agent.conf",
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
          name = "spire-agent"
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
            mount_path = "/run/spire/bundle"
            name       = "spire-bundle"
          }
          volume_mount {
            mount_path = "/run/secrets/workload-spiffe-uds"
            name       = "spire-agent-socket-dir"
          }
          volume_mount {
            mount_path = "/var/run/secrets/tokens"
            name       = "spire-token"
          }
        }
        container {
          args = [
            "-node-id",
            "CSI_NODE",
            "-workload-api-socket-dir",
            "/spire-agent-socket",
            "-csi-socket-path",
            "/spiffe-csi/csi.sock",
          ]
          image             = "${var.csi_driver.hub}:${var.csi_driver.tag}"
          image_pull_policy = "IfNotPresent"
          name              = "spiffe-csi-driver"
          security_context {
            privileged = true
          }
          volume_mount {
            mount_path = "/spire-agent-socket"
            name       = "spire-agent-socket-dir"
            read_only  = true
          }
          volume_mount {
            mount_path = "/spiffe-csi"
            name       = "spiffe-csi-socket-dir"
          }
          volume_mount {
            mount_path        = var.csi_driver.mount_path
            mount_propagation = "Bidirectional"
            name              = "mountpoint-dir"
          }
        }
        container {
          args = [
            "-csi-address",
            "/spiffe-csi/csi.sock",
            "-kubelet-registration-path",
            "/var/lib/kubelet/plugins/csi.spiffe.io/csi.sock",
          ]
          image             = "registry.k8s.io/sig-storage/csi-node-driver-registrar:v2.4.0"
          image_pull_policy = "IfNotPresent"
          name              = "node-driver-registrar"
          volume_mount {
            mount_path = "/spiffe-csi"
            name       = "spiffe-csi-socket-dir"
          }
          volume_mount {
            mount_path = "/registration"
            name       = "kubelet-plugin-registration-dir"
          }
        }
        dns_policy   = "ClusterFirstWithHostNet"
        host_network = true
        host_pid     = true
        init_container {
          args = [
            "-t",
            "30",
            "${var.spire_server.address}:${var.spire_server.port}",
          ]
          image = "gcr.io/spiffe-io/wait-for-it"
          name  = "init"
        }
        service_account_name = kubernetes_service_account_v1.spire-agent.metadata.0.name
        volume {
          config_map {
            name = kubernetes_config_map_v1.spire-agent.metadata.0.name
          }
          name = "spire-config"
        }
        volume {
          config_map {
            name = var.trust_bundle.name
          }
          name = "spire-bundle"
        }
        volume {
          name = "spire-token"
          projected {
            sources {
              service_account_token {
                audience           = "spire-server"
                expiration_seconds = 7200
                path               = "spire-agent"
              }
            }
          }
        }
        volume {
          host_path {
            path = "/run/spire/socket-dir"
            type = "DirectoryOrCreate"
          }
          name = "spire-agent-socket-dir"
        }
        volume {
          host_path {
            path = "/var/lib/kubelet/plugins/csi.spiffe.io"
            type = "DirectoryOrCreate"
          }
          name = "spiffe-csi-socket-dir"
        }
        volume {
          host_path {
            path = "/var/lib/kubelet/pods"
            type = "Directory"
          }
          name = "mountpoint-dir"
        }
        volume {
          host_path {
            path = "/var/lib/kubelet/plugins_registry"
            type = "Directory"
          }
          name = "kubelet-plugin-registration-dir"
        }
      }
    }
  }
  depends_on = [
    kubernetes_config_map_v1.trust-bundle,
    kubernetes_service_account_v1.spire-agent,
    kubernetes_config_map_v1.spire-agent
  ]
}