# Stacks are meant to be used to group together modules. Generally, this is where business-specific logic goes. Use "make create-stack name='stack_name'" to generate a stack. It is often useful to start here and then abstract generic logic to the app/modules folder.

# Within each stack folder, you can have a tfvars folder and define different variables. You can use [tfvars layering](https://terraspace.cloud/docs/layering/layering/) to use the same code to create different environments. For example: app/stack/demo/tfvars
