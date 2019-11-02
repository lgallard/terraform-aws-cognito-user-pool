# terraform-aws-cognito-user-pool

lambda_config: Default value don't define any value. Set any value for lambda_config\_* variables or define a lambda_config block to define the lambda triggers. To remove all lambda triggers define the lambda_config block with an empty map {}, apply the plan and then comment the lambda_config block or define it as `null`. This is needed because all paramters for lambda_config block are optional and keeping all block attributes empty or null forces to create a lambda_config {} block very time a plan/apply is run.
