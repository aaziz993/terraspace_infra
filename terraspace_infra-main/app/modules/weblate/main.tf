# This is where you put your resource declaration
resource "kubernetes_namespace" "weblate" {
  count    = var.namespace.create ? 1 : 0
  metadata {
    name        = var.namespace.metadata.name
    labels      = var.namespace.metadata.labels
    annotations = var.namespace.metadata.annotations
  }
}

resource "helm_release" "weblate" {
  repository       = "https://helm.weblate.org"
  chart            = "weblate"
  version          = var.chart_version
  create_namespace = false
  namespace        = var.namespace.create ? kubernetes_namespace.trust-manager.0.id : var.namespace.metadata.name
  name             = var.name

  set {
    name  = "nodeSelector"
    value = var.node_selector
  }

  set {
    name  = "replicaCount"
    value = var.replicas
  }

  set {
    name  = "adminEmail"
    value = var.admin.email
  }

  set {
    name  = "adminUser"
    value = var.admin.user
  }

  set {
    name  = "adminPassword"
    value = var.admin.password
  }

  set {
    name  = "allowedHosts"
    value = join(var.allow_hosts, ",")
  }

  set {
    name  = "caCertSecretName"
    value = var.ca.secret_name
  }

  set {
    name  = "caCertSubPath"
    value = var.ca.cert_sub_path
  }

  set {
    name  = "debug"
    value = var.debug
  }

  set {
    name  = "defaultFromEmail"
    value = var.default_from_email
  }

  set {
    name  = "emailHost"
    value = var.email.host
  }

  set {
    name  = "emailPassword"
    value = var.email.password
  }

  set {
    name  = "emailPort"
    value = var.email.port
  }

  set {
    name  = "emailSSL"
    value = var.email.ssl
  }

  set {
    name  = "emailTLS"
    value = var.email.tls
  }

  set {
    name  = "emailUser"
    value = var.email.user
  }

  set {
    name  = "existingSecret"
    value = var.existing.secret
  }

  set {
    name  = "externalSecretName"
    value = var.external_secret_name
  }

  set {
    name  = "extraSecretConfig"
    value =
  }
  set {
    name  = "extraVolumeMounts"
    value =
  }
  set {
    name  = "extraVolumes"
    value =
  }
  set {
    name  = "fullnameOverride"
    value =
  }
  set {
    name  = "image.pullPolicy"
    value =
  }
  set {
    name  = "image.repository"
    value =
  }
  set {
    name  = "image.tag"
    value =
  }
  set {
    name  = "imagePullSecrets"
    value =
  }

  set {
    name  = "ingress.annotations"
    value = var.ingress.annotations
  }

  set {
    name  = "ingress.enabled"
    value = var.ingress.enabled
  }

  set {
    name  = "ingress.hosts[0].host"
    value = var.ingress.host
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = var.ingress.path
  }

  set {
    name  = "ingress.ingress.hosts[0].paths[0].pathType"
    value = var.ingress.path_type
  }

  set {
    name  = "ingress.ingressClassName"
    value = var.ingress.class_name
  }

  set {
    name  = "ingress.tls"
    value = var.ingress.tls
  }

  set {
    name  = "labels"
    value = var.labels
  }

  set {
    name  = "persistence.accessMode"
    value = var.persistence.access_mode
  }

  set {
    name  = "persistence.enabled"
    value = var.persistence.enabled
  }

  set {
    name  = "persistence.existingClaim"
    value = var.persistence.existing_claim
  }

  set {
    name  = "persistence.filestore_dir"
    value = var.persistence.filestore_dir
  }

  set {
    name  = "persistence.size"
    value = var.persistence.size
  }

  set {
    name  = "postgresql.auth.database"
    value = var.postgresql.auth.database
  }

  set {
    name  = "postgresql.auth.enablePostgresUser"
    value = var.postgresql.auth.enable_postgres_user
  }

  set {
    name  = "postgresql.auth.existingSecret"
    value = var.postgresql.auth.existing_secret
  }

  set {
    name  = "postgresql.auth.postgresPassword"
    value = var.postgresql.auth.postgres_password
  }

  set {
    name  = "postgresql.auth.secretKeys.userPasswordKey"
    value = var.postgresql.auth.secret_keys.user_password_key
  }

  set {
    name  = "postgresql.enabled"
    value = var.postgresql.enabled
  }

  set {
    name  = "postgresql.postgresqlHost"
    value = var.postgresql.host
  }

  set {
    name  = "postgresql.service.ports.postgresql"
    value = var.postgresql.service.ports.postgresql
  }

  set {
    name  = "redis.architecture"
    value = var.redis.architecture
  }

  set {
    name  = "redis.auth.enabled"
    value = var.redis.auth.enabled
  }
  set {
    name  = "redis.auth.existingSecret"
    value = var.redis.auth.existing_secret
  }
  set {
    name  = "redis.auth.existingSecretPasswordKey"
    value = var.redis.auth.existing_secret_password_key
  }
  set {
    name  = "redis.auth.password"
    value = var.redis.auth.password
  }
  set {
    name  = "redis.db"
    value = var.redis.db
  }
  set {
    name  = "redis.enabled"
    value = var.redis.enabled
  }
  set {
    name  = "redis.redisHost"
    value = var.redis.host
  }

  set {
    name  = "serverEmail"
    value = var.server.email
  }

  set {
    name  = "service.annotations"
    value = var.service.annotations
  }

  set {
    name  = "service.port"
    value = var.service.port
  }

  set {
    name  = "service.type"
    value = var.service.type
  }

  set {
    name  = "serviceAccount.create"
    value = var.service_account.name
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account.name
  }

  set {
    name  = "siteDomain"
    value = var.site.domain
  }

  set {
    name  = "siteTitle"
    value = var.site.title
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  values = flatten([
    var.resources==null?[] : [
      yamlencode({
        resources = var.resources
      })
    ],
    var.extra_config==null?[] : [
      yamlencode({
        extraConfig = var.extra_config
      })
    ],
    var.extra_secret_config==null?[] : [
      yamlencode({
        extraSecretConfig = var.extra_secret_config
      })
    ],
    var.extra_volume_mounts==null?[] : [
      yamlencode({
        extraVolumeMounts = var.extra_volume_mounts
      })
    ],
    var.extra_volumes==null?[] : [
      yamlencode({
        extraVolumeMounts = var.extra_volume_mounts
      })
    ],
  ])
}