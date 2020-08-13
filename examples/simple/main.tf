module "aws_cognito_user_pool_simple_example" {

  source = "lgallard/cognito-user-pool/aws"

  user_pool_name = "simple_pool"

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
