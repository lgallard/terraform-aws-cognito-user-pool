variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}

variable "enabled" {
  description = "Whether to create the user pool"
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

variable "software_token_mfa_configuration" {
  description = "Software token MFA configuration"
  type        = map(any)
  default     = {}
}

variable "auto_verified_attributes" {
  description = "Auto verified attributes"
  type        = list(string)
  default     = []
}

variable "username_attributes" {
  description = "Username attributes"
  type        = list(string)
  default     = []
}

variable "deletion_protection" {
  description = "Deletion protection"
  type        = string
  default     = "INACTIVE"
}

variable "clients" {
  description = "User pool clients configuration"
  type        = map(any)
  default     = {}
}

variable "domain" {
  description = "User pool domain"
  type        = string
  default     = null
}

variable "user_groups" {
  description = "User groups configuration"
  type        = list(any)
  default     = []
}

variable "recovery_mechanisms" {
  description = "Recovery mechanisms for account recovery"
  type        = list(any)
  default     = []
}

variable "user_pool_add_ons" {
  description = "User pool add-ons"
  type        = map(any)
  default     = {}
}

variable "device_configuration" {
  description = "Device configuration"
  type        = map(any)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
