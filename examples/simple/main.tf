module "aws_cognito_user_pool_simple_example" {

  source = "../../"

  user_pool_name = "simple_pool"

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas in the future
  ignore_schema_changes = true

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
