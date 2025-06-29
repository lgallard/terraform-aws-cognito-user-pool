module "aws_cognito_user_pool_email_mfa_example" {
  source = "../../"

  user_pool_name = "email_mfa_pool"

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas
  ignore_schema_changes = true

  # Email configuration
  email_configuration = {
    email_sending_account = "DEVELOPER"
    from_email_address    = "noreply@example.com"
    source_arn            = "arn:aws:ses:us-east-1:123456789012:identity/example.com"
  }

  # Email MFA configuration
  email_mfa_configuration = {
    message = "Your verification code is {####}"
    subject = "Your verification code"
  }

  # Account recovery settings (required for email MFA)
  recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    },
    {
      name     = "verified_phone_number"
      priority = 2
    }
  ]

  # MFA configuration
  mfa_configuration = "ON"

  # Auto verify email
  auto_verified_attributes = ["email"]

  # Tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
