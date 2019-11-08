module "aws_cognito_user_pool_complete" {

  source = "../modules/erraform-aws-cognito-user-pool"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    unused_account_validity_days = 9
    email_subject                = "Here, your verification code baby"
  }

  device_configuration = {
    challenge_required_on_new_device      = true
    device_only_remembered_on_user_prompt = true
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

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

}
