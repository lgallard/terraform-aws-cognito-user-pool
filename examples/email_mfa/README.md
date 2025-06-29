# Email MFA Configuration Example

This example demonstrates how to configure a Cognito User Pool with email-based Multi-Factor Authentication (MFA).

## Features

- Email-based MFA configuration
- Email configuration using Amazon SES
- Account recovery settings
- Auto-verified email attributes
- **Best practices**: Includes `ignore_schema_changes` for future-proofing

## Usage

```hcl
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
    reply_to_email_address = "reply@example.com"
    configuration_set      = "my-configuration-set"
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
}
```

## Requirements

- AWS SES configured and verified domain/email
- Valid SES source ARN
- At least two account recovery mechanisms configured

## Notes

- The `email_sending_account` must be set to "DEVELOPER" to use Amazon SES
- The `source_arn` must be a valid SES ARN
- At least two account recovery mechanisms are required when using email MFA
- The `{####}` placeholder in the message will be replaced with the verification code
