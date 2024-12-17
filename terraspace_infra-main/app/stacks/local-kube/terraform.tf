terraform {
  required_version = "<%= ENV['TERRAFORM_VERSION'] %>"
  required_providers {
    local = {
      source  = "<%= ENV['LOCAL_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['LOCAL_PROVIDER_VERSION'] %>"
    }
    kubernetes = {
      source  = "<%= ENV['KUBERNETES_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['KUBERNETES_PROVIDER_VERSION'] %>"
    }
    kubectl = {
      source  = "<%= ENV['KUBECTL_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['KUBECTL_PROVIDER_VERSION'] %>"
    }
    helm = {
      source  = "<%= ENV['HELM_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['HELM_PROVIDER_VERSION'] %>"
    }
    kustomization = {
      source  = "<%= ENV['KUSTOMIZATION_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['KUSTOMIZATION_PROVIDER_VERSION'] %>"
    }
    netris = {
      source  = "<%= ENV['NETRIS_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['NETRIS_PROVIDER_VERSION'] %>"
    }
    minio = {
      # ATTENTION: use the current version here!
      source  = "<%= ENV['MINIO_PROVIDER_SOURCE'] %>"
      version = "<%= ENV['MINIO_PROVIDER_VERSION'] %>"
    }
  }
}