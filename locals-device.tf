#
# Device Configuration Locals
#
# This file contains locals for managing device configuration settings
# including challenge requirements and device memory settings.
#

locals {
  # device_configuration
  # Simplified device configuration logic using modern Terraform syntax

  # Check if device configuration is provided
  device_config_provided = length(var.device_configuration) > 0

  # Extract device configuration values with fallbacks
  device_configuration_values = local.device_config_provided ? {
    challenge_required_on_new_device      = try(var.device_configuration.challenge_required_on_new_device, var.device_configuration_challenge_required_on_new_device)
    device_only_remembered_on_user_prompt = try(var.device_configuration.device_only_remembered_on_user_prompt, var.device_configuration_device_only_remembered_on_user_prompt)
  } : {}

  # Check if device configuration differs from AWS defaults or has null values
  device_challenge_set = try(local.device_configuration_values.challenge_required_on_new_device, null) != null
  device_prompt_set = try(local.device_configuration_values.device_only_remembered_on_user_prompt, null) != null
  device_challenge_enabled = try(local.device_configuration_values.challenge_required_on_new_device, false) != false
  device_prompt_enabled = try(local.device_configuration_values.device_only_remembered_on_user_prompt, false) != false

  # Only include device configuration block if values differ from AWS defaults or are explicitly set
  device_configuration_needed = local.device_config_provided && (
    !local.device_challenge_set || !local.device_prompt_set ||
    local.device_challenge_enabled || local.device_prompt_enabled
  )

  device_configuration = local.device_configuration_needed ? [local.device_configuration_values] : []
}