# terraform-aws-cognito-user-pool

Terraform module to create [Amazon Cognito User Pools](https://aws.amazon.com/cognito/). Amazon Cognito User Pools provide a secure user directory that scales to hundreds of millions of users. As a fully managed service, User Pools are easy to set up without any worries about standing up server infrastructure.

## Usage user_pool

You can use this module to create a Cognito User Pool using the default values or use the detailed definition to set every aspect of the Cognito User Poo

Check the [examples](examples/) for the  **minimal** example using the default values, or the **detailed**  example with a complete example.

### Example (simple)

This simple example creates a AWS Cognito User Pool with the default values:

```
module "aws_cognito_user_pool_simple" {

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name = "mypool"

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
```

### Example (complete)

This more complete example creates a AWS Cognito User Pool using a detailed configuration. Please check the example folder to get the example with all options:

```
module "aws_cognito_user_pool_complete" {

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    unused_account_validity_days = 9
    email_subject                = "Here, your verification code baby"
  }

  email_configuration = {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = "email@example.com"
    source_arn             = "arn:aws:ses:us-east-1:888888888888:identity/example.com"
  }

  password_policy = {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schemas = [
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = false
      mutable                  = true
      name                     = "available"
      required                 = false
    },
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = true
      mutable                  = true
      name                     = "registered"
      required                 = false
    }
  ]

  string_schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      name                     = "email"
      required                 = true

      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    }
  ]

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

```

**NOTE:** lambda_config: Default value don't define any value. Set any value for lambda_config\_* variables or define a lambda_config block to define the lambda triggers. To remove all lambda triggers define the lambda_config block with an empty map {}, apply the plan and then comment the lambda_config block or define it as `null`. This is needed because all paramters for lambda_config block are optional and keeping all block attributes empty or null forces to create a lambda_config {} block very time a plan/apply is run.