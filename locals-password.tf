#
# Password Policy Configuration Locals
#
# This file contains locals for managing password policy settings
# including complexity requirements and password validity.
#

locals {
  # password_policy
  # Build password policy configuration using modern Terraform syntax

  # Default password policy when no configuration is provided
  password_policy_defaults = {
    minimum_length                   = var.password_policy_minimum_length
    require_lowercase                = var.password_policy_require_lowercase
    require_numbers                  = var.password_policy_require_numbers
    require_symbols                  = var.password_policy_require_symbols
    require_uppercase                = var.password_policy_require_uppercase
    temporary_password_validity_days = var.password_policy_temporary_password_validity_days
    password_history_size            = var.password_policy_password_history_size
  }

  # Password policy with fallback to defaults
  password_policy_configuration = var.password_policy == null ? local.password_policy_defaults : {
    minimum_length                   = try(var.password_policy.minimum_length, var.password_policy_minimum_length)
    require_lowercase                = try(var.password_policy.require_lowercase, var.password_policy_require_lowercase)
    require_numbers                  = try(var.password_policy.require_numbers, var.password_policy_require_numbers)
    require_symbols                  = try(var.password_policy.require_symbols, var.password_policy_require_symbols)
    require_uppercase                = try(var.password_policy.require_uppercase, var.password_policy_require_uppercase)
    temporary_password_validity_days = try(var.password_policy.temporary_password_validity_days, var.password_policy_temporary_password_validity_days)
    password_history_size            = try(var.password_policy.password_history_size, var.password_policy_password_history_size)
  }

  password_policy = [local.password_policy_configuration]
}
