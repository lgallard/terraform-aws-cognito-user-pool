#
# Lambda Configuration Locals
#
# This file contains locals for managing Lambda trigger configurations
# including authentication challenges, custom messages, and various triggers.
#

locals {
  # lambda_config
  # Build lambda configuration using modern Terraform syntax
  lambda_config_default = {
    create_auth_challenge          = try(var.lambda_config.create_auth_challenge, var.lambda_config_create_auth_challenge)
    custom_message                 = try(var.lambda_config.custom_message, var.lambda_config_custom_message)
    define_auth_challenge          = try(var.lambda_config.define_auth_challenge, var.lambda_config_define_auth_challenge)
    post_authentication            = try(var.lambda_config.post_authentication, var.lambda_config_post_authentication)
    post_confirmation              = try(var.lambda_config.post_confirmation, var.lambda_config_post_confirmation)
    pre_authentication             = try(var.lambda_config.pre_authentication, var.lambda_config_pre_authentication)
    pre_sign_up                    = try(var.lambda_config.pre_sign_up, var.lambda_config_pre_sign_up)
    pre_token_generation           = try(var.lambda_config.pre_token_generation, var.lambda_config_pre_token_generation)
    pre_token_generation_config    = length(try(var.lambda_config.pre_token_generation_config, var.lambda_config_pre_token_generation_config, {})) == 0 ? [] : [try(var.lambda_config.pre_token_generation_config, var.lambda_config_pre_token_generation_config)]
    user_migration                 = try(var.lambda_config.user_migration, var.lambda_config_user_migration)
    verify_auth_challenge_response = try(var.lambda_config.verify_auth_challenge_response, var.lambda_config_verify_auth_challenge_response)
    kms_key_id                     = try(var.lambda_config.kms_key_id, var.lambda_config_kms_key_id)
    custom_email_sender            = length(try(var.lambda_config.custom_email_sender, var.lambda_config_custom_email_sender, {})) == 0 ? [] : [try(var.lambda_config.custom_email_sender, var.lambda_config_custom_email_sender)]
    custom_sms_sender              = length(try(var.lambda_config.custom_sms_sender, var.lambda_config_custom_sms_sender, {})) == 0 ? [] : [try(var.lambda_config.custom_sms_sender, var.lambda_config_custom_sms_sender)]
  }

  lambda_config = var.lambda_config == null || length(var.lambda_config) == 0 ? [] : [local.lambda_config_default]
}
