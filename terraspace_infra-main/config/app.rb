# Docs: https://terraspace.cloud/docs/config/reference/

class AllowEnvs
  def call(stack)
    %w[dev test staging prod]
  end
end

class DenyEnvs
  def call(stack)
    # returns nil when nothing provided
  end
end

class AllowRegions
  def call(stack)
    # returns nil when nothing provided
  end
end

class DenyRegions
  def call(stack)
    # returns nil when nothing provided
  end
end

class AllowStacks
  def call(stack)
    # returns nil when nothing provided
  end
end

class DenyStacks
  def call(stack)
    # returns nil when nothing provided
  end
end

class BuildDir
  def call(mod)
    ".terraspace-cache#{ENV['KUBE_REGION'] ? "/#{ENV['KUBE_REGION']}" : ""}#{ENV['KUBE_ACCOUNT'] ? "/#{ENV['KUBE_ACCOUNT']}" : ""}#{ENV['PROJECT'] ? "/:PROJECT" : ""}#{ENV['APP'] ? "/:APP" : ""}#{ENV['ROLE'] ? "/:ROLE" : ""}/:ENV#{ENV['EXTRA'] ? "/:EXTRA" : ""}/:BUILD_DIR"
    # String is returned
  end
end

Terraspace.configure do |config|
  config.logger.level = :info
  config.test_framework = "rspec"
  config.all.concurrency = 5

  # To enable Terraspace Cloud set config.cloud.org
  # config.cloud.org = "AITech"          # required: replace with your org. only letters, numbers, underscore and dashes allowed
  # config.cloud.project = "main"     # optional. main is the default project name. only letters, numbers, underscore and dashes allowed
  # config.cloud.token = ENV['TS_TOKEN']

  # Uncomment to enable Cost Estimation. See: http://terraspace.cloud/docs/cloud/cost-estimation/
  # config.cloud.cost.enabled = true

  # To see the layers being used
  config.layering.show = true
  # Layering modes are: simple, namespace, or provider
  config.layering.mode = "provider"

  # You can configure additional patterns to use the pass strategy.
  config.build.pass_files = []

  # Restrict environments
  # If you want to restrict environments that can be deployed, you can use:
  # Note: If both deny and allow is set, deny rules always wins over allow rules.

  config.allow.envs = AllowEnvs
  config.deny.envs = DenyEnvs

  # Restrict regions
  # If you want to restrict which regions can be deployed, you can use:
  # Note: If both deny and allow is set, deny rules always wins over allow rules.
  config.allow.regions = AllowRegions
  config.deny.regions = DenyRegions

  # If you want to restrict which stacks can be deployed to, you can use:
  # Note: If both deny and allow is set, deny rules always wins over allow rules.
  config.allow.stacks = AllowStacks
  config.deny.stacks = DenyStacks

  # The build.cache_dir setting controls where the generated terraform project will be built. It’s set to a reasonable and conventional default. If you wish, you also can override and fully control the path. Here’s the default:
  config.build.cache_root = nil # defaults to /full/path/to/.terraspace-cache
  config.build.cache_dir = BuildDir # ":REGION/:APP/:ROLE/:ENV/:BUILD_DIR" - default

end