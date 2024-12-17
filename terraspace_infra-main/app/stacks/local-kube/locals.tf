locals {
  # ---------------------------------------------GLOBAL VARIABLES-------------------------------------------------------
  env    = "<%= Terraspace.env %>"
  region = "<%= ENV['KUBE_REGION'] %>"

  # ------------------------------------------------TERRAFORM-----------------------------------------------------------
  backend_secret_prefix = "<%= ENV['BACKEND_SECRET_SUFFIX'] %>"

  # ------------------------------------------------KUBERNETES----------------------------------------------------------
  kube = {
    config_path  = "<%= ENV['KUBECONFIG'] %>"
    cluster_name = "<%= ENV['CLUSTER_NAME'] %>"
  }

  # -------------------------------------------S3 BACKEND VARIABLES-----------------------------------------------------
  s3 = {
    endpoint          = "<%= ENV['S3_ENDPOINT'] %>"
    access_key_id     = "<%= ENV['S3_ACCESS_KEY_ID'] %>"
    secret_access_key = "<%= ENV['S3_SECRET_ACCESS_KEY'] %>"
  }
}