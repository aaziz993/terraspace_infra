# Common code that gets built with the deployed stack. It can be dynamically controlled to keep your code DRY.

# A useful example might be to create a global terraform.tfvars file. Remember, Terraform automatically loads all files in the directory with the exact name of terraform.tfvars.

# You can configure the backend for terraform to use with config/terraform/backend.tf. Below are examples.

  * ## You may also be interested in:

    * ### Statefile Approaches and Thoughts
    * ### Configuring Backends for Existing Systems

  * ## Backend Examples
    * [S3](https://terraspace.cloud/docs/config/backend/examples/s3/)
    * [Azurerm](https://terraspace.cloud/docs/config/backend/examples/azurerm/)
    * [GCS](https://terraspace.cloud/docs/config/backend/examples/gcs/)
    * [Remote TFC](https://terraspace.cloud/docs/config/backend/examples/remote/)
    * [Local](https://terraspace.cloud/docs/config/backend/examples/local/)
    * [GitLab](https://terraspace.cloud/docs/config/backend/examples/gitlab/)

# You can configure the backend for terraform to use with config/terraform/provider.rb or config/terraform/provider.tf. The files in the config folder get built with the module you deploy.

# A useful example might be to create a global locals.tf file.

# The config/terraform/terraform.tf is a good spot for general Terraform settings. For example, you may want to lock the version of Terraform and providers. Terraform and providers sometime releases new versions that are not backwards compatible. Note: If you are using Terraform Cloud or Enterprise, the terraform.tf is not used. [Terraform Cloud](https://www.terraform.io/cloud-docs/workspaces/variables) will override the terraform.tf and it’s settings are used instead.