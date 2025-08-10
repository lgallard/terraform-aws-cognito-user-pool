variable "user_pool_name" {
  description = "The name of the user pool"
  type        = string
}

variable "user_pool_tier" {
  type        = string
  description = "Cognito User Pool tier. Valid values: LITE, ESSENTIALS, PLUS."
  default     = "ESSENTIALS"
  validation {
    condition     = contains(["LITE", "ESSENTIALS", "PLUS"], var.user_pool_tier)
    error_message = "user_pool_tier must be one of: LITE, ESSENTIALS, PLUS"
  }
}

variable "enabled" {
  description = "Change to false to avoid deploying any resources"
  type        = bool
  default     = true
}

variable "password_policy" {
  description = "Password policy configuration"
  type        = map(any)
  default     = {}
}

variable "mfa_configuration" {
  description = "MFA configuration"
  type        = string
  default     = "OFF"
}

variable "user_pool_add_ons_advanced_security_additional_flows" {
  description = "Mode of threat protection operation in custom authentication. Valid values are AUDIT or ENFORCED. Default is AUDIT"
  type        = string
  default     = null

  validation {
    condition     = var.user_pool_add_ons_advanced_security_additional_flows == null ? true : contains(["AUDIT", "ENFORCED"], var.user_pool_add_ons_advanced_security_additional_flows)
    error_message = "Invalid custom_auth_mode. Valid values: AUDIT, ENFORCED"
  }
}

# This configuration just validates the variables without creating resources
# The key is that Terraform evaluates variable validation during planning

# Trigger evaluation by using the variables in locals
locals {
  # Force evaluation of all variables to trigger validation
  force_validation = {
    user_pool_name                                       = var.user_pool_name
    user_pool_tier                                       = var.user_pool_tier
    enabled                                              = var.enabled
    password_policy                                      = var.password_policy
    mfa_configuration                                    = var.mfa_configuration
    user_pool_add_ons_advanced_security_additional_flows = var.user_pool_add_ons_advanced_security_additional_flows
  }
}

output "validation_result" {
  value = "Validation passed for ${var.user_pool_name} with tier ${var.user_pool_tier}"
}
