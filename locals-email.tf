#
# Email Configuration Locals
#
# This file contains locals for managing email configuration settings
# including SES configuration, verification templates, and MFA settings.
#

locals {
  # email_configuration
  # Build email configuration using modern Terraform syntax
  email_configuration_default = {
    configuration_set      = try(var.email_configuration.configuration_set, var.email_configuration_configuration_set)
    reply_to_email_address = try(var.email_configuration.reply_to_email_address, var.email_configuration_reply_to_email_address)
    source_arn             = try(var.email_configuration.source_arn, var.email_configuration_source_arn)
    email_sending_account  = try(var.email_configuration.email_sending_account, var.email_configuration_email_sending_account)
    from_email_address     = try(var.email_configuration.from_email_address, var.email_configuration_from_email_address)
  }

  email_configuration = [local.email_configuration_default]

  # email_mfa_configuration
  email_mfa_configuration = var.email_mfa_configuration == null ? [] : [var.email_mfa_configuration]

  # verification_message_template
  # Build verification message template using modern Terraform syntax
  verification_message_template_default = {
    default_email_option  = try(var.verification_message_template.default_email_option, var.verification_message_template_default_email_option)
    email_message         = try(var.verification_message_template.email_message, var.verification_message_template_email_message)
    email_message_by_link = try(var.verification_message_template.email_message_by_link, var.verification_message_template_email_message_by_link)
    email_subject         = try(var.verification_message_template.email_subject, var.verification_message_template_email_subject)
    email_subject_by_link = try(var.verification_message_template.email_subject_by_link, var.verification_message_template_email_subject_by_link)
    sms_message           = try(var.verification_message_template.sms_message, var.verification_message_template_sms_message)
  }

  verification_message_template = [local.verification_message_template_default]

  # Verification email settings with improved fallback logic
  verification_email_subject = try(local.verification_message_template_default.email_subject, "") == "" ? (
    coalesce(var.email_verification_subject, var.admin_create_user_config_email_subject)
  ) : null

  verification_email_message = try(local.verification_message_template_default.email_message, "") == "" ? (
    coalesce(var.email_verification_message, var.admin_create_user_config_email_message)
  ) : null
}