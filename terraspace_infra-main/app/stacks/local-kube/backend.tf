# This is where you put your backend declaration. Example:
#
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }
#
# More examples: https://terraspace.cloud/docs/config/backend/examples/
#

terraform {
  backend "kubernetes" {
    secret_suffix = "<%= expansion("#{ENV['KUBE_REGION']?ENV['KUBE_REGION']+'-':''}#{ENV['KUBE_ACCOUNT']?ENV['KUBE_ACCOUNT']+'-':''}#{ENV['PROJECT'] ? ':PROJECT-' : ''}:TYPE_DIR-#{ENV['APP'] ? ':APP-' : ''}#{ENV['ROLE'] ? ':ROLE-' : ''}:MOD_NAME-:ENV-#{ENV['EXTRA'] ? ':EXTRA-' : ''}") %>-terraform.tfstate"
    config_path   = "<%= ENV['KUBECONFIG'] %>"
  }
}