# Terraspace supports customizing the args passed to the terraform commands. See [Config Args Docs](https://terraspace.cloud/docs/config/args/).

# You can customize CLI arguments in 3 different ways or “levels”.

  * ## Project-level: Customizing args at the Terraspace project-level will adjust the args for all stacks. The args customizations are defined in the config/args folder. These customizations can be overridden at the stack-level or module-level.
  * ## Stack-level: Customizing args the stack level will adjust only the args for the stack. For example, app/stacks/demo. The args customizations are defined in the app/stacks/demo/config/args folder.
  * ## Module-level: Customizing args the stack module level will adjust only the args for the module. For example, app/modules/example. The args customizations are defined in the app/modules/example/config/args folder. Also, these args customizations only applied when deploying the module directly without a stack. Deploying modules directly is generally not recommended, hence module-level args customizations are not recommended. Terraspace implements them only for completeness.

# There are many ways to customize args, so you may be unsure which one is right to use. When in doubt, use stack-level args customizations. Start with customizing a specific stack and then go from there.

# Args Docs

  * ## [Terraform Args](https://terraspace.cloud/docs/config/args/terraform/)
  * ## [Arg Generator](https://terraspace.cloud/docs/config/args/generator/)