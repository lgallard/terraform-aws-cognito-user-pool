resource "aws_cognito_user_pool" "pool" {
  name = var.user_pool_name

  alias_attributes           = var.alias_attributes
  email_verification_message = var.email_verification_message

  # admin_create_user_config
  dynamic "admin_create_user_config" {
    for_each = local.admin_create_user_config
    content {
      allow_admin_create_user_only = lookup(admin_create_user_config.value, "allow_admin_create_user_only")
      unused_account_validity_days = lookup(admin_create_user_config.value, "unused_account_validity_days")

      dynamic "invite_message_template" {
        for_each = lookup(admin_create_user_config.value, "email_message", null) == null && lookup(admin_create_user_config.value, "email_subject", null) == null && lookup(admin_create_user_config.value, "sms_message", null) == null ? [] : [1]
        content {
          email_message = lookup(admin_create_user_config.value, "email_message")
          email_subject = lookup(admin_create_user_config.value, "email_subject")
          sms_message   = lookup(admin_create_user_config.value, "sms_message")
        }
      }
    }
  }
}

locals {
  # admin_create_user_config
  # If no admin_create_user_config list is provided, build a admin_create_user_config using the default values
  admin_create_user_config_default = {
    allow_admin_create_user_only = lookup(var.admin_create_user_config, "allow_admin_create_user_only", null) == null ? var.admin_create_user_config_allow_admin_create_user_only : lookup(var.admin_create_user_config, "allow_admin_create_user_only")
    unused_account_validity_days = lookup(var.admin_create_user_config, "unused_account_validity_days", null) == null ? var.admin_create_user_config_unused_account_validity_days : lookup(var.admin_create_user_config, "unused_account_validity_days")
    email_message                = lookup(var.admin_create_user_config, "email_message", null) == null ? var.admin_create_user_config_email_message : lookup(var.admin_create_user_config, "email_message")
    email_subject                = lookup(var.admin_create_user_config, "email_subject", null) == null ? var.admin_create_user_config_email_subject : lookup(var.admin_create_user_config, "email_subject")
    sms_message                  = lookup(var.admin_create_user_config, "sms_message", null) == null ? var.admin_create_user_config_sms_message : lookup(var.admin_create_user_config, "sms_message")

  }

  admin_create_user_config = [local.admin_create_user_config_default]
}
