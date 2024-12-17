# ----------------------------------------------------LOCAL FILES-------------------------------------------------------
ENV['LOCAL_PROVIDER_SOURCE'] ||= 'hashicorp/local'
ENV['LOCAL_PROVIDER_VERSION'] ||= '>= 2.4.0'

# ----------------------------------------------------KUBERNETES--------------------------------------------------------
ENV['KUBE_REGION'] ||= 'asia-central'
ENV['KUBE_ACCOUNT'] ||= 'admin'
ENV['KUBECONFIG'] ||= '~/.kube/config'
ENV['CLUSTER_NAME'] ||= 'cluster.local'
ENV['KUBERNETES_PROVIDER_SOURCE'] ||= 'hashicorp/kubernetes'
ENV['KUBERNETES_PROVIDER_VERSION'] ||= '>= 2.18.1'
ENV['KUBECTL_PROVIDER_SOURCE'] ||= 'gavinbunney/kubectl'
ENV['KUBECTL_PROVIDER_VERSION'] ||= '>= 1.14.0'
ENV['HELM_PROVIDER_SOURCE'] ||= 'hashicorp/helm'
ENV['HELM_PROVIDER_VERSION'] ||= '>= 2.9.0'
ENV['KUSTOMIZATION_PROVIDER_SOURCE'] ||= 'kbst/kustomization'
ENV['KUSTOMIZATION_PROVIDER_VERSION'] ||= '>= 0.9.0'

# ----------------------------------------------------TERRAFORM---------------------------------------------------------
ENV['TERRAFORM_VERSION'] ||= '>= 1.4.4'

# -----------------------------------------------------S3 BACKEND-------------------------------------------------------
ENV['MINIO_PROVIDER_SOURCE'] ||= 'refaktory/minio'
ENV['MINIO_PROVIDER_VERSION'] ||= '>= 0.1.0'

# -------------------------------------------------------NETRIS---------------------------------------------------------
ENV['NETRIS_PROVIDER_SOURCE'] ||= 'netrisai/netris'
ENV['NETRIS_PROVIDER_VERSION'] ||= '>= 2.1.0'
