variable "user_pool_name" {
  description = "The name of the user pool"
  type        = string
}

variable "email_verification_message" {
  description = "A string representing the email verification message. Conflicts with `verification_message_template` configuration block `email_message` argument"
  type        = string
  default     = null
}

# admin_create_user_config
variable "admin_create_user_config" {
  description = "The configuration for AdminCreateUser requests"
  type        = map
  default     = {}
}

variable "admin_create_user_config_allow_admin_create_user_only" {
  description = "Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app"
  type        = bool
  default     = true
}

variable "admin_create_user_config_unused_account_validity_days" {
  description = "The user account expiration limit, in days, after which the account is no longer usable"
  type        = number
  default     = 7
}

variable "admin_create_user_config_email_message" {
  description = "The message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively"
  type        = string
  default     = "{username}, your verification code is {####}."
}


variable "admin_create_user_config_email_subject" {
  description = "The subject line for email messages"
  type        = string
  default     = "Your verification code"
}

variable "admin_create_user_config_sms_message" {
  description = "- The message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively"
  type        = string
  default     = "Your username is {username} and temporary password is {####}."
}

variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list
  default     = []
}
