#
# Admin Create User Configuration Locals
#
# This file contains locals for managing admin create user configuration
# including email and SMS message settings for user invitations.
#

locals {
  # admin_create_user_config
  # Build admin_create_user_config using modern Terraform syntax and default values
  admin_create_user_config_default = {
    allow_admin_create_user_only = try(var.admin_create_user_config.allow_admin_create_user_only, var.admin_create_user_config_allow_admin_create_user_only)
    email_message                = try(var.admin_create_user_config.email_message, coalesce(var.email_verification_message, var.admin_create_user_config_email_message))
    email_subject                = try(var.admin_create_user_config.email_subject, coalesce(var.email_verification_subject, var.admin_create_user_config_email_subject))
    sms_message                  = try(var.admin_create_user_config.sms_message, var.admin_create_user_config_sms_message)
  }

  admin_create_user_config = [local.admin_create_user_config_default]
}