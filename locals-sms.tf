#
# SMS Configuration Locals
#
# This file contains locals for managing SMS configuration settings
# including SNS caller ARN and external ID for SMS sending.
#

locals {
  # sms_configuration
  # Build SMS configuration using modern Terraform syntax
  sms_configuration_default = {
    external_id    = try(var.sms_configuration.external_id, var.sms_configuration_external_id)
    sns_caller_arn = try(var.sms_configuration.sns_caller_arn, var.sms_configuration_sns_caller_arn)
  }

  # Only include SMS configuration if both required fields are provided
  sms_configuration = (
    try(local.sms_configuration_default.external_id, "") == "" ||
    try(local.sms_configuration_default.sns_caller_arn, "") == ""
  ) ? [] : [local.sms_configuration_default]

  # software_token_mfa_configuration
  # Build software token MFA configuration using modern Terraform syntax
  software_token_mfa_configuration_default = {
    enabled = try(var.software_token_mfa_configuration.enabled, var.software_token_mfa_configuration_enabled)
  }

  # Only include software token MFA if SMS is configured or MFA is not OFF
  software_token_mfa_configuration = (
    length(var.sms_configuration) == 0 || local.sms_configuration == null
  ) && var.mfa_configuration == "OFF" ? [] : [local.software_token_mfa_configuration_default]
}
