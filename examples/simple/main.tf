module "aws_cognito_user_pool_simple_example" {

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name = "simple_pool"

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
