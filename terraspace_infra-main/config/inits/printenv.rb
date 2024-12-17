puts "ENVIRONMENT VARIABLES"

# -----------------------------------------------------TERRAFORM--------------------------------------------------------
puts "TERRAFORM_VERSION=#{ENV['TERRAFORM_VERSION'].inspect}"

# -----------------------------------------------------INFRACOST-------------------------------------------------------
puts "INFRACOST_API_KEY=#{ENV['INFRACOST_API_KEY'].inspect}"

# -----------------------------------------------------TERRASPACE-------------------------------------------------------
puts "TS_TOKEN=#{ENV['TS_TOKEN'].inspect}"
puts "TS_LOG=#{ENV['TS_LOG'].inspect}"
puts "TS_ENV=#{ENV['TS_ENV'].inspect}"
puts "REGION=#{ENV['REGION'].inspect}"
puts "APP=#{ENV['APP'].inspect}"
puts "ROLE=#{ENV['ROLE'].inspect}"

# -----------------------------------------------------KUBERNETES-------------------------------------------------------
puts "CLUSTER_NAME=#{ENV['CLUSTER_NAME'].inspect}"
puts "KUBECONFIG=#{ENV['KUBECONFIG'].inspect}"
puts "KUBERNETES_PROVIDER_SOURCE=#{ENV['KUBERNETES_PROVIDER_SOURCE'].inspect}"
puts "KUBERNETES_PROVIDER_VERSION=#{ENV['KUBERNETES_PROVIDER_VERSION'].inspect}"
puts "KUBECTL_PROVIDER_SOURCE=#{ENV['KUBECTL_PROVIDER_SOURCE'].inspect}"
puts "KUBECTL_PROVIDER_VERSION=#{ENV['KUBECTL_PROVIDER_VERSION'].inspect}"
puts "HELM_PROVIDER_SOURCE=#{ENV['HELM_PROVIDER_SOURCE'].inspect}"
puts "HELM_PROVIDER_VERSION=#{ENV['HELM_PROVIDER_VERSION'].inspect}"
puts "KUSTOMIZATION_PROVIDER_SOURCE=#{ENV['KUSTOMIZATION_PROVIDER_SOURCE'].inspect}"
puts "KUSTOMIZATION_PROVIDER_VERSION=#{ENV['KUSTOMIZATION_PROVIDER_VERSION'].inspect}"

# -------------------------------------------------------S3 BACKEND---------------------------------------------------------
puts "MINIO_PROVIDER_SOURCE=#{ENV['MINIO_PROVIDER_SOURCE'].inspect}"
puts "MINIO_PROVIDER_VERSION=#{ENV['MINIO_PROVIDER_VERSION'].inspect}"
puts "S3_ENDPOINT=#{ENV['S3_ENDPOINT'].inspect}"

# -------------------------------------------------------NETRIS---------------------------------------------------------
puts "NETRIS_PROVIDER_SOURCE=#{ENV['NETRIS_PROVIDER_SOURCE'].inspect}"
puts "NETRIS_PROVIDER_VERSION=#{ENV['NETRIS_PROVIDER_VERSION'].inspect}"
puts "NETRIS_ADDRESS=#{ENV['NETRIS_ADDRESS'].inspect}"

puts ""