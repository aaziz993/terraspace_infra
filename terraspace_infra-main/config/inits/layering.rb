# Terraspace custom layering
Terraspace::Layering.module_eval do
  # def pre_layers
  #   []
  # end
  #
  # def main_layers
  #   super
  # end

  def post_layers
    (ENV['KUBE_REGION'] ? %W[#{ENV['KUBE_REGION']}] : []) + (ENV['KUBE_ACCOUNT'] ? %W[#{ENV['KUBE_ACCOUNT']}] : [])
  end
end