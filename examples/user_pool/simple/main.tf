module "aws_cognito_user_pool_simple" {

  source = "../modules/erraform-aws-cognito-user-pool"

  user_pool_name = "mypool"

  tags = {
    Owner       = "Infra"
    Environment = "production"
    Terraform   = true
  }

}
