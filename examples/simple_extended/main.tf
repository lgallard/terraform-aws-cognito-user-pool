module "aws_cognito_user_pool_simple_extended_example" {

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name                                     = "simple_extended_pool"
  alias_attributes                                   = ["email", "phone_number"]
  auto_verified_attributes                           = ["email"]
  sms_authentication_message                         = "Your username is {username} and temporary password is {####}."
  sms_verification_message                           = "This is the verification message {####}."
  lambda_config_verify_auth_challenge_response       = "arn:aws:lambda:us-east-1:123456789012:function:my_lambda_function"
  password_policy_require_lowercase                  = false
  password_policy_minimum_length                     = 11
  user_pool_add_ons_advanced_security_mode           = "OFF"
  verification_message_template_default_email_option = "CONFIRM_WITH_CODE"

  # schemas
  schemas = [
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = false
      mutable                  = true
      name                     = "available"
      required                 = false
    },
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
    },
  ]

  # user_pool_domain
  domain = "mydomain-com"

  # client
  client_name                                 = "client0"
  client_allowed_oauth_flows_user_pool_client = false
  client_callback_urls                        = ["https://mydomain.com/callback"]
  client_default_redirect_uri                 = "https://mydomain.com/callback"
  client_read_attributes                      = ["email"]
  client_refresh_token_validity               = 30


  # user_group
  user_group_name        = "mygroup"
  user_group_description = "My group"

  # ressource server
  resource_server_identifier        = "https://mydomain.com"
  resource_server_name              = "mydomain"
  resource_server_scope_name        = "scope"
  resource_server_scope_description = "a Sample Scope Description for mydomain"

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
