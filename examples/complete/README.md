# This is a complete example

```
module "aws_cognito_user_pool_complete_example" {

  source = "lgallard/cognito-user-pool/aws"

  user_pool_name             = "mypool_complete"
  alias_attributes           = ["email", "phone_number"]
  auto_verified_attributes   = ["email"]
  sms_authentication_message = "Your username is {username} and temporary password is {####}."
  sms_verification_message   = "This is the verification message {####}."

  deletion_protection = "ACTIVE"

  mfa_configuration = "OPTIONAL"
  software_token_mfa_configuration = {
    enabled = true
  }

  admin_create_user_config = {
    email_message = "Dear {username}, your verification code is {####}."
    email_subject = "Here, your verification code baby"
    sms_message   = "Your username is {username} and temporary password is {####}."
  }

  device_configuration = {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
  }

  email_configuration = {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = "email@mydomain.com"
    source_arn             = "arn:aws:ses:us-east-1:123456789012:identity/myemail@mydomain.com"
  }

  lambda_config = {
    create_auth_challenge          = "arn:aws:lambda:us-east-1:123456789012:function:create_auth_challenge"
    custom_message                 = "arn:aws:lambda:us-east-1:123456789012:function:custom_message"
    define_auth_challenge          = "arn:aws:lambda:us-east-1:123456789012:function:define_auth_challenge"
    post_authentication            = "arn:aws:lambda:us-east-1:123456789012:function:post_authentication"
    post_confirmation              = "arn:aws:lambda:us-east-1:123456789012:function:post_confirmation"
    pre_authentication             = "arn:aws:lambda:us-east-1:123456789012:function:pre_authentication"
    pre_sign_up                    = "arn:aws:lambda:us-east-1:123456789012:function:pre_sign_up"
    pre_token_generation           = "arn:aws:lambda:us-east-1:123456789012:function:pre_token_generation"
    user_migration                 = "arn:aws:lambda:us-east-1:123456789012:function:user_migration"
    verify_auth_challenge_response = "arn:aws:lambda:us-east-1:123456789012:function:verify_auth_challenge_response"
  }

  password_policy = {
    minimum_length                   = 10
    require_lowercase                = false
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 120

  }

  user_pool_add_ons = {
    advanced_security_mode = "ENFORCED"
  }

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_CODE"
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
    },
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      name                     = "gender"
      required                 = true

      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    },
  ]

  number_schemas = [
    {
      attribute_data_type      = "Number"
      developer_only_attribute = true
      mutable                  = true
      name                     = "mynumber1"
      required                 = false

      number_attribute_constraints = {
        min_value = 2
        max_value = 6
      }
    },
    {
      attribute_data_type      = "Number"
      developer_only_attribute = true
      mutable                  = true
      name                     = "mynumber2"
      required                 = false

      number_attribute_constraints = {
        min_value = 2
        max_value = 6
      }
    },
  ]

  # user_pool_domain
  domain = "mydomain-com"

  # clients
  clients = [
    {
      allowed_oauth_flows                  = []
      allowed_oauth_flows_user_pool_client = false
      allowed_oauth_scopes                 = []
      callback_urls                        = ["https://mydomain.com/callback"]
      default_redirect_uri                 = "https://mydomain.com/callback"
      explicit_auth_flows                  = []
      generate_secret                      = true
      logout_urls                          = []
      name                                 = "test1"
      read_attributes                      = ["email"]
      supported_identity_providers         = []
      write_attributes                     = []
      access_token_validity                = 1
      id_token_validity                    = 1
      refresh_token_validity               = 60
      token_validity_units = {
        access_token  = "hours"
        id_token      = "hours"
        refresh_token = "days"
      }
    },
    {
      allowed_oauth_flows                  = []
      allowed_oauth_flows_user_pool_client = false
      allowed_oauth_scopes                 = []
      callback_urls                        = ["https://mydomain.com/callback"]
      default_redirect_uri                 = "https://mydomain.com/callback"
      explicit_auth_flows                  = []
      generate_secret                      = false
      logout_urls                          = []
      name                                 = "test2"
      read_attributes                      = []
      supported_identity_providers         = []
      write_attributes                     = []
      refresh_token_validity               = 30
    },
    {
      allowed_oauth_flows                  = ["code", "implicit"]
      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_scopes                 = ["email", "openid"]
      callback_urls                        = ["https://mydomain.com/callback"]
      default_redirect_uri                 = "https://mydomain.com/callback"
      explicit_auth_flows                  = ["CUSTOM_AUTH_FLOW_ONLY", "ADMIN_NO_SRP_AUTH"]
      generate_secret                      = false
      logout_urls                          = ["https://mydomain.com/logout"]
      name                                 = "test3"
      read_attributes                      = ["email", "phone_number"]
      supported_identity_providers         = []
      write_attributes                     = ["email", "gender", "locale", ]
      refresh_token_validity               = 30
    }
  ]

  # user_group
  user_groups = [
    { name        = "mygroup1"
      description = "My group 1"
    },
    { name        = "mygroup2"
      description = "My group 2"
    },
  ]

  # resource_servers
  resource_servers = [
    {
      identifier = "https://mydomain.com"
      name       = "mydomain"
      scope = [
        {
          scope_name        = "sample-scope-1"
          scope_description = "A sample Scope Description for mydomain.com"
        },
        {
          scope_name        = "sample-scope-2"
          scope_description = "Another sample Scope Description for mydomain.com"
        },
      ]
    },
    {
      identifier = "https://weather-read-app.com"
      name       = "weather-read"
      scope = [
        {
          scope_name        = "weather.read"
          scope_description = "Read weather forecasts"
        }
      ]
    }
  ]

  # identity_providers
  identity_providers = [
    {
      provider_name = "Google"
      provider_type = "Google"

      provider_details = {
        authorize_scopes = "email"
        client_id        = "your client_id"
        client_secret    = "your client_secret"
      }

      attribute_mapping = {
        email    = "email"
        username = "sub"
        gender   = "gender"
      }
    }
  ]

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```
