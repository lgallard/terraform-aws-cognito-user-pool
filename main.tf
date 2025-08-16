resource "aws_cognito_user_pool" "pool" {
  count = var.enabled && !var.ignore_schema_changes ? 1 : 0

  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  name                       = var.user_pool_name
  email_verification_subject = local.verification_email_subject
  email_verification_message = local.verification_email_message
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message
  sms_verification_message   = var.sms_verification_message
  username_attributes        = var.username_attributes
  deletion_protection        = var.deletion_protection
  user_pool_tier             = var.user_pool_tier

  # username_configuration
  dynamic "username_configuration" {
    for_each = local.username_configuration
    content {
      case_sensitive = lookup(username_configuration.value, "case_sensitive", true)
    }
  }

  # admin_create_user_config
  dynamic "admin_create_user_config" {
    for_each = local.admin_create_user_config
    content {
      allow_admin_create_user_only = lookup(admin_create_user_config.value, "allow_admin_create_user_only", true)

      dynamic "invite_message_template" {
        for_each = lookup(admin_create_user_config.value, "email_message", null) == null && lookup(admin_create_user_config.value, "email_subject", null) == null && lookup(admin_create_user_config.value, "sms_message", null) == null ? [] : [1]
        content {
          email_message = lookup(admin_create_user_config.value, "email_message", null)
          email_subject = lookup(admin_create_user_config.value, "email_subject", null)
          sms_message   = lookup(admin_create_user_config.value, "sms_message", null)
        }
      }
    }
  }

  # device_configuration
  dynamic "device_configuration" {
    for_each = local.device_configuration
    content {
      challenge_required_on_new_device      = lookup(device_configuration.value, "challenge_required_on_new_device", false)
      device_only_remembered_on_user_prompt = lookup(device_configuration.value, "device_only_remembered_on_user_prompt", false)
    }
  }

  # email_configuration
  dynamic "email_configuration" {
    for_each = local.email_configuration
    content {
      configuration_set      = lookup(email_configuration.value, "configuration_set", null)
      reply_to_email_address = lookup(email_configuration.value, "reply_to_email_address", null)
      source_arn             = lookup(email_configuration.value, "source_arn", null)
      email_sending_account  = lookup(email_configuration.value, "email_sending_account", "COGNITO_DEFAULT")
      from_email_address     = lookup(email_configuration.value, "from_email_address", null)
    }
  }

  # email_mfa_configuration
  dynamic "email_mfa_configuration" {
    for_each = local.email_mfa_configuration
    content {
      message = email_mfa_configuration.value.message
      subject = email_mfa_configuration.value.subject
    }
  }

  # lambda_config
  dynamic "lambda_config" {
    for_each = local.lambda_config
    content {
      create_auth_challenge = lookup(lambda_config.value, "create_auth_challenge")
      custom_message        = lookup(lambda_config.value, "custom_message")
      define_auth_challenge = lookup(lambda_config.value, "define_auth_challenge")
      post_authentication   = lookup(lambda_config.value, "post_authentication")
      post_confirmation     = lookup(lambda_config.value, "post_confirmation")
      pre_authentication    = lookup(lambda_config.value, "pre_authentication")
      pre_sign_up           = lookup(lambda_config.value, "pre_sign_up")
      pre_token_generation  = lookup(lambda_config.value, "pre_token_generation")
      dynamic "pre_token_generation_config" {
        for_each = lookup(lambda_config.value, "pre_token_generation_config")
        content {
          lambda_arn     = lookup(pre_token_generation_config.value, "lambda_arn")
          lambda_version = lookup(pre_token_generation_config.value, "lambda_version")
        }
      }
      user_migration                 = lookup(lambda_config.value, "user_migration")
      verify_auth_challenge_response = lookup(lambda_config.value, "verify_auth_challenge_response")
      kms_key_id                     = lookup(lambda_config.value, "kms_key_id")
      dynamic "custom_email_sender" {
        for_each = lookup(lambda_config.value, "custom_email_sender")
        content {
          lambda_arn     = lookup(custom_email_sender.value, "lambda_arn")
          lambda_version = lookup(custom_email_sender.value, "lambda_version")
        }
      }
      dynamic "custom_sms_sender" {
        for_each = lookup(lambda_config.value, "custom_sms_sender")
        content {
          lambda_arn     = lookup(custom_sms_sender.value, "lambda_arn")
          lambda_version = lookup(custom_sms_sender.value, "lambda_version")
        }
      }
    }
  }

  # sms_configuration
  dynamic "sms_configuration" {
    for_each = local.sms_configuration
    content {
      external_id    = lookup(sms_configuration.value, "external_id")
      sns_caller_arn = lookup(sms_configuration.value, "sns_caller_arn")
    }
  }

  # software_token_mfa_configuration
  dynamic "software_token_mfa_configuration" {
    for_each = local.software_token_mfa_configuration
    content {
      enabled = lookup(software_token_mfa_configuration.value, "enabled")
    }
  }

  # password_policy
  dynamic "password_policy" {
    for_each = local.password_policy
    content {
      minimum_length                   = lookup(password_policy.value, "minimum_length")
      require_lowercase                = lookup(password_policy.value, "require_lowercase")
      require_numbers                  = lookup(password_policy.value, "require_numbers")
      require_symbols                  = lookup(password_policy.value, "require_symbols")
      require_uppercase                = lookup(password_policy.value, "require_uppercase")
      temporary_password_validity_days = lookup(password_policy.value, "temporary_password_validity_days")
      password_history_size            = lookup(password_policy.value, "password_history_size")
    }
  }

  # schema
  dynamic "schema" {
    for_each = var.schemas == null ? [] : var.schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")
    }
  }

  # schema (String)
  dynamic "schema" {
    for_each = var.string_schemas == null ? [] : var.string_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      # string_attribute_constraints
      dynamic "string_attribute_constraints" {
        for_each = length(keys(lookup(schema.value, "string_attribute_constraints", {}))) == 0 ? [{}] : [lookup(schema.value, "string_attribute_constraints", {})]
        content {
          min_length = lookup(string_attribute_constraints.value, "min_length", null)
          max_length = lookup(string_attribute_constraints.value, "max_length", null)
        }
      }
    }
  }

  # schema (Number)
  dynamic "schema" {
    for_each = var.number_schemas == null ? [] : var.number_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      # number_attribute_constraints
      dynamic "number_attribute_constraints" {
        for_each = length(keys(lookup(schema.value, "number_attribute_constraints", {}))) == 0 ? [{}] : [lookup(schema.value, "number_attribute_constraints", {})]
        content {
          min_value = lookup(number_attribute_constraints.value, "min_value", null)
          max_value = lookup(number_attribute_constraints.value, "max_value", null)
        }
      }
    }
  }

  # user_pool_add_ons
  dynamic "user_pool_add_ons" {
    for_each = local.user_pool_add_ons
    content {
      advanced_security_mode = lookup(user_pool_add_ons.value, "advanced_security_mode")

      dynamic "advanced_security_additional_flows" {
        for_each = lookup(user_pool_add_ons.value, "advanced_security_additional_flows") != null ? [1] : []
        content {
          custom_auth_mode = lookup(user_pool_add_ons.value, "advanced_security_additional_flows")
        }
      }
    }
  }

  # verification_message_template
  dynamic "verification_message_template" {
    for_each = local.verification_message_template
    content {
      default_email_option  = lookup(verification_message_template.value, "default_email_option", "CONFIRM_WITH_CODE")
      email_message         = lookup(verification_message_template.value, "email_message", null)
      email_message_by_link = lookup(verification_message_template.value, "email_message_by_link", null)
      email_subject         = lookup(verification_message_template.value, "email_subject", null)
      email_subject_by_link = lookup(verification_message_template.value, "email_subject_by_link", null)
      sms_message           = lookup(verification_message_template.value, "sms_message", null)
    }
  }


  dynamic "user_attribute_update_settings" {
    for_each = local.user_attribute_update_settings
    content {
      attributes_require_verification_before_update = lookup(user_attribute_update_settings.value, "attributes_require_verification_before_update")
    }
  }

  # account_recovery_setting
  dynamic "account_recovery_setting" {
    for_each = length(var.recovery_mechanisms) == 0 ? [] : [1]
    content {
      # recovery_mechanism
      dynamic "recovery_mechanism" {
        for_each = var.recovery_mechanisms
        content {
          name     = lookup(recovery_mechanism.value, "name")
          priority = lookup(recovery_mechanism.value, "priority")
        }
      }
    }
  }

  # sign_in_policy
  dynamic "sign_in_policy" {
    for_each = local.sign_in_policy
    content {
      allowed_first_auth_factors = lookup(sign_in_policy.value, "allowed_first_auth_factors")
    }
  }

  # tags
  tags = var.tags
}

# Separate resource definition with schema ignore_changes lifecycle
resource "aws_cognito_user_pool" "pool_with_schema_ignore" {
  count = var.enabled && var.ignore_schema_changes ? 1 : 0

  alias_attributes           = var.alias_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  name                       = var.user_pool_name
  email_verification_subject = local.verification_email_subject
  email_verification_message = local.verification_email_message
  mfa_configuration          = var.mfa_configuration
  sms_authentication_message = var.sms_authentication_message
  sms_verification_message   = var.sms_verification_message
  username_attributes        = var.username_attributes
  deletion_protection        = var.deletion_protection
  user_pool_tier             = var.user_pool_tier

  # username_configuration
  dynamic "username_configuration" {
    for_each = local.username_configuration
    content {
      case_sensitive = lookup(username_configuration.value, "case_sensitive", true)
    }
  }

  # admin_create_user_config
  dynamic "admin_create_user_config" {
    for_each = local.admin_create_user_config
    content {
      allow_admin_create_user_only = lookup(admin_create_user_config.value, "allow_admin_create_user_only", true)

      dynamic "invite_message_template" {
        for_each = lookup(admin_create_user_config.value, "email_message", null) == null && lookup(admin_create_user_config.value, "email_subject", null) == null && lookup(admin_create_user_config.value, "sms_message", null) == null ? [] : [1]
        content {
          email_message = lookup(admin_create_user_config.value, "email_message", null)
          email_subject = lookup(admin_create_user_config.value, "email_subject", null)
          sms_message   = lookup(admin_create_user_config.value, "sms_message", null)
        }
      }
    }
  }

  # device_configuration
  dynamic "device_configuration" {
    for_each = local.device_configuration
    content {
      challenge_required_on_new_device      = lookup(device_configuration.value, "challenge_required_on_new_device", false)
      device_only_remembered_on_user_prompt = lookup(device_configuration.value, "device_only_remembered_on_user_prompt", false)
    }
  }

  # email_configuration
  dynamic "email_configuration" {
    for_each = local.email_configuration
    content {
      configuration_set      = lookup(email_configuration.value, "configuration_set", null)
      reply_to_email_address = lookup(email_configuration.value, "reply_to_email_address", null)
      source_arn             = lookup(email_configuration.value, "source_arn", null)
      email_sending_account  = lookup(email_configuration.value, "email_sending_account", "COGNITO_DEFAULT")
      from_email_address     = lookup(email_configuration.value, "from_email_address", null)
    }
  }

  # email_mfa_configuration
  dynamic "email_mfa_configuration" {
    for_each = local.email_mfa_configuration
    content {
      message = email_mfa_configuration.value.message
      subject = email_mfa_configuration.value.subject
    }
  }

  # lambda_config
  dynamic "lambda_config" {
    for_each = local.lambda_config
    content {
      create_auth_challenge = lookup(lambda_config.value, "create_auth_challenge")
      custom_message        = lookup(lambda_config.value, "custom_message")
      define_auth_challenge = lookup(lambda_config.value, "define_auth_challenge")
      post_authentication   = lookup(lambda_config.value, "post_authentication")
      post_confirmation     = lookup(lambda_config.value, "post_confirmation")
      pre_authentication    = lookup(lambda_config.value, "pre_authentication")
      pre_sign_up           = lookup(lambda_config.value, "pre_sign_up")
      pre_token_generation  = lookup(lambda_config.value, "pre_token_generation")
      dynamic "pre_token_generation_config" {
        for_each = lookup(lambda_config.value, "pre_token_generation_config")
        content {
          lambda_arn     = lookup(pre_token_generation_config.value, "lambda_arn")
          lambda_version = lookup(pre_token_generation_config.value, "lambda_version")
        }
      }
      user_migration                 = lookup(lambda_config.value, "user_migration")
      verify_auth_challenge_response = lookup(lambda_config.value, "verify_auth_challenge_response")
      kms_key_id                     = lookup(lambda_config.value, "kms_key_id")
      dynamic "custom_email_sender" {
        for_each = lookup(lambda_config.value, "custom_email_sender")
        content {
          lambda_arn     = lookup(custom_email_sender.value, "lambda_arn")
          lambda_version = lookup(custom_email_sender.value, "lambda_version")
        }
      }
      dynamic "custom_sms_sender" {
        for_each = lookup(lambda_config.value, "custom_sms_sender")
        content {
          lambda_arn     = lookup(custom_sms_sender.value, "lambda_arn")
          lambda_version = lookup(custom_sms_sender.value, "lambda_version")
        }
      }
    }
  }

  # sms_configuration
  dynamic "sms_configuration" {
    for_each = local.sms_configuration
    content {
      external_id    = lookup(sms_configuration.value, "external_id")
      sns_caller_arn = lookup(sms_configuration.value, "sns_caller_arn")
    }
  }

  # software_token_mfa_configuration
  dynamic "software_token_mfa_configuration" {
    for_each = local.software_token_mfa_configuration
    content {
      enabled = lookup(software_token_mfa_configuration.value, "enabled")
    }
  }

  # password_policy
  dynamic "password_policy" {
    for_each = local.password_policy
    content {
      minimum_length                   = lookup(password_policy.value, "minimum_length")
      require_lowercase                = lookup(password_policy.value, "require_lowercase")
      require_numbers                  = lookup(password_policy.value, "require_numbers")
      require_symbols                  = lookup(password_policy.value, "require_symbols")
      require_uppercase                = lookup(password_policy.value, "require_uppercase")
      temporary_password_validity_days = lookup(password_policy.value, "temporary_password_validity_days")
      password_history_size            = lookup(password_policy.value, "password_history_size")
    }
  }

  # schema
  dynamic "schema" {
    for_each = var.schemas == null ? [] : var.schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")
    }
  }

  # schema (String)
  dynamic "schema" {
    for_each = var.string_schemas == null ? [] : var.string_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      # string_attribute_constraints
      dynamic "string_attribute_constraints" {
        for_each = length(keys(lookup(schema.value, "string_attribute_constraints", {}))) == 0 ? [{}] : [lookup(schema.value, "string_attribute_constraints", {})]
        content {
          min_length = lookup(string_attribute_constraints.value, "min_length", null)
          max_length = lookup(string_attribute_constraints.value, "max_length", null)
        }
      }
    }
  }

  # schema (Number)
  dynamic "schema" {
    for_each = var.number_schemas == null ? [] : var.number_schemas
    content {
      attribute_data_type      = lookup(schema.value, "attribute_data_type")
      developer_only_attribute = lookup(schema.value, "developer_only_attribute")
      mutable                  = lookup(schema.value, "mutable")
      name                     = lookup(schema.value, "name")
      required                 = lookup(schema.value, "required")

      # number_attribute_constraints
      dynamic "number_attribute_constraints" {
        for_each = length(keys(lookup(schema.value, "number_attribute_constraints", {}))) == 0 ? [{}] : [lookup(schema.value, "number_attribute_constraints", {})]
        content {
          min_value = lookup(number_attribute_constraints.value, "min_value", null)
          max_value = lookup(number_attribute_constraints.value, "max_value", null)
        }
      }
    }
  }

  # user_pool_add_ons
  dynamic "user_pool_add_ons" {
    for_each = local.user_pool_add_ons
    content {
      advanced_security_mode = lookup(user_pool_add_ons.value, "advanced_security_mode")

      dynamic "advanced_security_additional_flows" {
        for_each = lookup(user_pool_add_ons.value, "advanced_security_additional_flows") != null ? [1] : []
        content {
          custom_auth_mode = lookup(user_pool_add_ons.value, "advanced_security_additional_flows")
        }
      }
    }
  }

  # verification_message_template
  dynamic "verification_message_template" {
    for_each = local.verification_message_template
    content {
      default_email_option  = lookup(verification_message_template.value, "default_email_option", "CONFIRM_WITH_CODE")
      email_message         = lookup(verification_message_template.value, "email_message", null)
      email_message_by_link = lookup(verification_message_template.value, "email_message_by_link", null)
      email_subject         = lookup(verification_message_template.value, "email_subject", null)
      email_subject_by_link = lookup(verification_message_template.value, "email_subject_by_link", null)
      sms_message           = lookup(verification_message_template.value, "sms_message", null)
    }
  }

  dynamic "user_attribute_update_settings" {
    for_each = local.user_attribute_update_settings
    content {
      attributes_require_verification_before_update = lookup(user_attribute_update_settings.value, "attributes_require_verification_before_update")
    }
  }

  # account_recovery_setting
  dynamic "account_recovery_setting" {
    for_each = length(var.recovery_mechanisms) == 0 ? [] : [1]
    content {
      # recovery_mechanism
      dynamic "recovery_mechanism" {
        for_each = var.recovery_mechanisms
        content {
          name     = lookup(recovery_mechanism.value, "name")
          priority = lookup(recovery_mechanism.value, "priority")
        }
      }
    }
  }

  # sign_in_policy
  dynamic "sign_in_policy" {
    for_each = local.sign_in_policy
    content {
      allowed_first_auth_factors = lookup(sign_in_policy.value, "allowed_first_auth_factors")
    }
  }

  # tags
  tags = var.tags

  # lifecycle management to prevent perpetual diffs on schema changes
  lifecycle {
    ignore_changes = [schema]
  }
}

# Locals are now organized in separate files (locals-*.tf)
# This improves maintainability and readability of the configuration
