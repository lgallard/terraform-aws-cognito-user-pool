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

# Simple validation without creating resources
locals {
  validation_test = "Validation passed for ${var.user_pool_name} with tier ${var.user_pool_tier}"
}

output "validation_result" {
  value = local.validation_test
}