variable "user_pool_name" {
  description = "The name of the user pool"
  type        = string
}

variable "email_verification_message" {
  description = "A string representing the email verification message"
  type        = string
  default     = null
}

variable "email_verification_subject" {
  description = "A string representing the email verification subject"
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
  description = "The message template for email messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively"
  type        = string
  default     = "{username}, your verification code is `{####}`"
}


variable "admin_create_user_config_email_subject" {
  description = "The subject line for email messages"
  type        = string
  default     = "Your verification code"
}

variable "admin_create_user_config_sms_message" {
  description = "- The message template for SMS messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively"
  type        = string
  default     = "Your username is {username} and temporary password is `{####}`"
}

variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool. Possible values: phone_number, email, or preferred_username. Conflicts with `username_attributes`"
  type        = list
  default     = null
}

variable "username_attributes" {
  description = "Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes`"
  type        = list
  default     = null
}

variable "auto_verified_attributes" {
  description = "The attributes to be auto-verified. Possible values: email, phone_number"
  type        = list
  default     = []
}

# sms_configuration
variable "sms_configuration" {
  description = "The SMS Configuration"
  type        = map
  default     = {}
}

variable "sms_configuration_external_id" {
  description = "The external ID used in IAM role trust relationships"
  type        = string
  default     = ""
}

variable "sms_configuration_sns_caller_arn" {
  description = "The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume"
  type        = string
  default     = ""
}

# device_configuration
variable "device_configuration" {
  description = "The configuration for the user pool's device tracking"
  type        = map
  default     = {}
}

variable "device_configuration_challenge_required_on_new_device" {
  description = "Indicates whether a challenge is required on a new device. Only applicable to a new device"
  type        = bool
  default     = false
}

variable "device_configuration_device_only_remembered_on_user_prompt" {
  description = "If true, a device is only remembered on user prompt"
  type        = bool
  default     = false
}

# email_configuration
variable "email_configuration" {
  description = "The Email Configuration"
  type        = map
  default     = {}
}

variable "email_configuration_reply_to_email_address" {
  description = "The REPLY-TO email address"
  type        = string
  default     = ""
}

variable "email_configuration_source_arn" {
  description = "The ARN of the email source"
  type        = string
  default     = ""
}

variable "email_configuration_email_sending_account" {
  description = "Instruct Cognito to either use its built-in functional or Amazon SES to send out emails. Allowed values: `COGNITO_DEFAULT` or `DEVELOPER`"
  type        = string
  default     = "COGNITO_DEFAULT"
}

# lambda_config
variable "lambda_config" {
  description = "A container for the AWS Lambda triggers associated with the user pool"
  type        = map
  default     = null
}

variable "lambda_config_create_auth_challenge" {
  description = "The ARN of the lambda creating an authentication challenge."
  type        = string
  default     = ""
}

variable "lambda_config_custom_message" {
  description = "A custom Message AWS Lambda trigger."
  type        = string
  default     = ""
}

variable "lambda_config_define_auth_challenge" {
  description = "Defines the authentication challenge."
  type        = string
  default     = ""
}

variable "lambda_config_post_authentication" {
  description = "A post-authentication AWS Lambda trigger"
  type        = string
  default     = ""
}

variable "lambda_config_post_confirmation" {
  description = "A post-confirmation AWS Lambda trigger"
  type        = string
  default     = ""
}

variable "lambda_config_pre_authentication" {
  description = "A pre-authentication AWS Lambda trigger"
  type        = string
  default     = ""
}
variable "lambda_config_pre_sign_up" {
  description = "A pre-registration AWS Lambda trigger"
  type        = string
  default     = ""
}

variable "lambda_config_pre_token_generation" {
  description = "Allow to customize identity token claims before token generation"
  type        = string
  default     = ""
}

variable "lambda_config_user_migration" {
  description = "The user migration Lambda config type"
  type        = string
  default     = ""
}

variable "lambda_config_verify_auth_challenge_response" {
  description = "Verifies the authentication challenge response"
  type        = string
  default     = ""
}

variable "mfa_configuration" {
  description = "Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL)"
  type        = string
  default     = "OFF"
}

# password_policy
variable "password_policy" {
  description = "A container for information about the user pool password policy"
  type = object({
    minimum_length    = number,
    require_lowercase = bool,
    require_lowercase = bool,
    require_numbers   = bool,
    require_symbols   = bool,
    require_uppercase = bool
  })
  default = null
}

variable "password_policy_minimum_length" {
  description = "The minimum length of the password policy that you have set"
  type        = number
  default     = 8
}

variable "password_policy_require_lowercase" {
  description = "Whether you have required users to use at least one lowercase letter in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_numbers" {
  description = "Whether you have required users to use at least one number in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_symbols" {
  description = "Whether you have required users to use at least one symbol in their password"
  type        = bool
  default     = true
}

variable "password_policy_require_uppercase" {
  description = "Whether you have required users to use at least one uppercase letter in their password"
  type        = bool
  default     = true
}

# schema
variable "schemas" {
  description = "A container with the schema attributes of a user pool. Maximum of 50 attributes"
  type        = list
  default     = []
}
variable "string_schemas" {
  description = "A container with the string schema attributes of a user pool. Maximum of 50 attributes"
  type        = list
  default     = []
}

variable "number_schemas" {
  description = "A container with the number schema attributes of a user pool. Maximum of 50 attributes"
  type        = list
  default     = []
}

# sms messages
variable "sms_authentication_message" {
  description = "A string representing the SMS authentication message"
  type        = string
  default     = null
}

variable "sms_verification_message" {
  description = "A string representing the SMS verification message"
  type        = string
  default     = null
}

# tags
variable "tags" {
  description = "A mapping of tags to assign to the User Pool"
  type        = map(string)
  default     = {}
}

# user_pool_add_ons
variable "user_pool_add_ons" {
  description = "Configuration block for user pool add-ons to enable user pool advanced security mode features"
  type        = map
  default     = {}
}

variable "user_pool_add_ons_advanced_security_mode" {
  description = "The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED`"
  type        = string
  default     = null
}

# verification_message_template
variable "verification_message_template" {
  description = "The verification message templates configuration"
  type        = map
  default     = {}
}

variable "verification_message_template_default_email_option" {
  description = "The default email option. Must be either `CONFIRM_WITH_CODE` or `CONFIRM_WITH_LINK`. Defaults to `CONFIRM_WITH_CODE`"
  type        = string
  default     = null
}

variable "verification_message_template_email_message_by_link" {
  description = "The email message template for sending a confirmation link to the user, it must contain the `{##Click Here##}` placeholder"
  type        = string
  default     = null
}

variable "verification_message_template_email_subject_by_link" {
  description = "The subject line for the email message template for sending a confirmation link to the user"
  type        = string
  default     = null
}
