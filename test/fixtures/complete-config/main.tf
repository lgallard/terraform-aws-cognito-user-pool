module "cognito_user_pool_test" {
  source = "../../../"

  user_pool_name = var.user_pool_name
  enabled        = var.enabled

  # Password policy
  password_policy = var.password_policy

  # MFA configuration
  mfa_configuration                = var.mfa_configuration
  software_token_mfa_configuration = var.software_token_mfa_configuration

  # User pool configuration
  auto_verified_attributes = var.auto_verified_attributes
  username_attributes      = var.username_attributes
  deletion_protection      = var.deletion_protection

  # Clients
  clients = var.clients

  # Domain
  domain = var.domain

  # User groups
  user_groups = var.user_groups

  # Account recovery
  account_recovery_setting = var.account_recovery_setting

  # Advanced security
  user_pool_add_ons = var.user_pool_add_ons

  # Device configuration
  device_configuration = var.device_configuration

  # Tags
  tags = var.tags
}
