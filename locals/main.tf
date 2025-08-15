#
# Core User Pool Configuration Locals
#
# This file contains core locals for the user pool resource management
# and other general configuration settings.
#

locals {
  # Get the user pool resource and ID regardless of which variant is created
  user_pool = var.enabled ? (
    var.ignore_schema_changes ? aws_cognito_user_pool.pool_with_schema_ignore[0] : aws_cognito_user_pool.pool[0]
  ) : null
  user_pool_id = var.enabled ? local.user_pool.id : null

  # username_configuration
  # Build username configuration with case sensitivity settings
  username_configuration_default = length(var.username_configuration) == 0 ? {} : {
    case_sensitive = try(var.username_configuration.case_sensitive, true)
  }
  username_configuration = length(local.username_configuration_default) == 0 ? [] : [local.username_configuration_default]

  # user_pool_add_ons
  # Build user pool add-ons configuration for advanced security features
  user_pool_add_ons_default = {
    advanced_security_mode             = try(var.user_pool_add_ons.advanced_security_mode, var.user_pool_add_ons_advanced_security_mode)
    advanced_security_additional_flows = try(var.user_pool_add_ons.advanced_security_additional_flows, var.user_pool_add_ons_advanced_security_additional_flows)
  }

  # Only include user pool add-ons if any advanced security features are configured
  user_pool_add_ons = (
    var.user_pool_add_ons_advanced_security_mode == null && 
    var.user_pool_add_ons_advanced_security_additional_flows == null && 
    length(var.user_pool_add_ons) == 0
  ) ? [] : [local.user_pool_add_ons_default]

  # user_attribute_update_settings
  # Configure which attributes require verification before update
  user_attribute_update_settings = var.user_attribute_update_settings == null ? (
    length(var.auto_verified_attributes) > 0 ? [{ 
      attributes_require_verification_before_update = var.auto_verified_attributes 
    }] : []
  ) : [var.user_attribute_update_settings]

  # sign_in_policy
  # Build sign-in policy configuration for allowed authentication factors
  sign_in_policy_default = {
    allowed_first_auth_factors = var.sign_in_policy == null ? var.sign_in_policy_allowed_first_auth_factors : (
      try(var.sign_in_policy.allowed_first_auth_factors, var.sign_in_policy_allowed_first_auth_factors)
    )
  }

  # Only include sign-in policy if factors are configured
  sign_in_policy = (
    var.sign_in_policy == null && 
    length(var.sign_in_policy_allowed_first_auth_factors) == 0
  ) ? [] : [local.sign_in_policy_default]
}
