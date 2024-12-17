# This is where you put your provider declaration.
#
# If you end up adding a cloud provider, you should also configure a terraspace_plugin_* gem
# in the Terraspace project Gemfile and run bundle.
#
# See: https://terraspace.cloud/docs/plugins/

provider "local" {
  # Configuration options
}

provider "kubernetes" {
  config_path = pathexpand(local.kube.config_path)
}

provider "kubectl" {
  # Same config as in kubernetes provider
  config_path = pathexpand(local.kube.config_path)
}

provider "helm" {
  # Several Kubernetes authentication methods are possible: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#authentication
  kubernetes {
    config_path = pathexpand(local.kube.config_path)
  }
}

provider "kustomization" {
  kubeconfig_path = pathexpand(local.kube.config_path)
}

provider "minio" {
  # The Minio server endpoint.
  # NOTE: do NOT add an http:// or https:// prefix!
  # Set the `ssl = true/false` setting instead.
  # Minio url
  endpoint   = element(split("://", local.s3.endpoint), 1)
  # Specify your minio user access key here.
  access_key = local.s3.access_key_id
  # Specify your minio user secret key here.
  secret_key = local.s3.secret_access_key
  # If true, the server will be contacted via https://
  ssl        = element(split("://", local.s3.endpoint), 1)=="https"
}

provider "netris" {
  # can be set by environment variables: NETRIS_ADDRESS, NETRIS_LOGIN and NETRIS_PASSWORD
}

