![Terraform](https://lgallardo.com/images/terraform.jpg)
# terraform-aws-cognito-user-pool

Terraform module to create [Amazon Cognito User Pools](https://aws.amazon.com/cognito/), configure its attributes and resources such as  **app clients**, **domain**, **resource servers**. Amazon Cognito User Pools provide a secure user directory that scales to hundreds of millions of users. As a fully managed service, User Pools are easy to set up without any worries about standing up server infrastructure.

## Usage

You can use this module to create a Cognito User Pool using the default values or use the detailed definition to set every aspect of the Cognito User Pool

Check the [examples](examples/) where you can see the **simple** example using the default values, the **simple_extended** version which adds  **app clients**, **domain**, **resource servers** resources, or the **complete** version with a detailed example.

### Example (simple)

This simple example creates a AWS Cognito User Pool with the default values:

```hcl
module "aws_cognito_user_pool_simple" {
  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name = "mypool"

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas
  ignore_schema_changes = true

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```

### Example (conditional creation)

If you need to create Cognito User Pool resources conditionally in ealierform  versions such as 0.11, 0,12 and 0.13 you can set the input variable `enabled` to false:

```hcl
# This Cognito User Pool will not be created
module "aws_cognito_user_pool_conditional_creation" {
  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name = "conditional_user_pool"

  enabled = false

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas
  ignore_schema_changes = true

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```

For Terraform 0.14 and later you can use `count` inside `module` blocks, or use the input variable `enabled` as described above.

### Example (complete)

This more complete example creates a AWS Cognito User Pool using a detailed configuration. Please check the example folder to get the example with all options:

```hcl
module "aws_cognito_user_pool_complete" {
  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]
  user_pool_tier           = "ESSENTIALS" # Valid values: LITE, ESSENTIALS, PLUS. Default is ESSENTIALS

  deletion_protection = "ACTIVE"

  # IMPORTANT: Enable schema ignore changes to prevent perpetual diffs with custom schemas
  # This is ESSENTIAL for new deployments using custom schemas to avoid AWS API errors
  ignore_schema_changes = true

  admin_create_user_config = {
    email_subject = "Here, your verification code baby"
  }

  email_configuration = {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = "email@example.com"
    source_arn             = "arn:aws:ses:us-east-1:888888888888:identity/example.com"
    from_email_address     = "noreply@example.com"
    configuration_set      = "my-configuration-set"
  }

  password_policy = {
    minimum_length    = 10
    require_lowercase = false
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  schemas = [
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = false
      mutable                  = true
      name                     = "available"
      required                 = false
    },
    {
      attribute_data_type      = "Boolean"
      developer_only_attribute = true
      mutable                  = true
      name                     = "registered"
      required                 = false
    }
  ]

  string_schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = false
      name                     = "email"
      required                 = true

      string_attribute_constraints = {
        min_length = 7
        max_length = 15
      }
    }
  ]

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

  sign_in_policy = {
    allowed_first_auth_factors = ["PASSWORD", "EMAIL_OTP", "SMS_OTP"]
  }

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```

## Schema Management

### ⚠️ **Important: Schema Perpetual Diff Fix Available**

**RECOMMENDATION FOR NEW DEPLOYMENTS: Set `ignore_schema_changes = true`** to avoid schema-related issues from the start.

**If you're experiencing perpetual diffs with custom schemas, this module provides an opt-in fix.** The fix is disabled by default to ensure backward compatibility with existing deployments, but **new deployments should enable it proactively**.

### The Schema Perpetual Diff Problem

AWS Cognito User Pool schemas cannot be modified or removed after creation. However, due to how the AWS API returns schema information (with different ordering and additional empty constraint blocks), Terraform shows perpetual diffs and attempts to recreate schemas on every plan:

```
- schema {
  - attribute_data_type      = "String" -> null
  - developer_only_attribute = false -> null
  - mutable                  = true -> null
  - name                     = "roles" -> null
  - required                 = false -> null
  - string_attribute_constraints {}
}
+ schema {
  + attribute_data_type      = "String"
  + developer_only_attribute = false
  + mutable                  = true
  + name                     = "roles"
  + required                 = false
}
```

This results in AWS API errors since schema attributes are immutable after creation.

### ✅ **Solution: Enable Schema Change Ignore**

To fix this issue, set `ignore_schema_changes = true`:

```hcl
module "aws_cognito_user_pool" {
  source = "lgallard/cognito-user-pool/aws"

  user_pool_name = "mypool"

  # Enable this to prevent perpetual diffs with custom schemas
  ignore_schema_changes = true

  schemas = [
    {
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      name                     = "roles"
      required                 = false
    }
  ]

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```

### 🔧 **Technical Implementation Details**

**Why Terraform Doesn't Support Conditional `ignore_changes`:**

Terraform's lifecycle blocks require static values because they affect dependency graph construction. According to the [official documentation](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle):

> "The lifecycle settings all affect how Terraform constructs and traverses the dependency graph. As a result, only literal values can be used because the processing happens too early for arbitrary expression evaluation."

This means expressions like `ignore_changes = var.ignore_schema_changes ? [schema] : []` are not supported.

**Dual-Resource Approach:**

To work around this limitation, the module uses a dual-resource approach:
- One `aws_cognito_user_pool` resource without lifecycle ignore (default behavior)
- One `aws_cognito_user_pool` resource with `lifecycle { ignore_changes = [schema] }`
- Conditional creation based on the `ignore_schema_changes` variable
- All other resources reference the appropriate user pool via a local value

### 🔄 **Migration for Existing Deployments**

If you have an existing deployment and want to enable the fix:

1. **For new deployments with custom schemas**: Always set `ignore_schema_changes = true`

2. **For existing deployments experiencing the issue**:
   ```hcl
   # Enable the fix in your configuration
   ignore_schema_changes = true
   ```

   Then run:
   ```bash
   # Plan to see the changes
   terraform plan

   # Apply - this will create the new resource variant
   terraform apply

   # Import existing state to the new resource
   terraform state mv aws_cognito_user_pool.pool[0] aws_cognito_user_pool.pool_with_schema_ignore[0]
   ```

### 📝 **Adding New Schema Attributes**

**Important:** Once a schema attribute is created in Cognito, it cannot be modified or removed. Plan your schema carefully.

If you need to add new schema attributes after enabling `ignore_schema_changes = true`:

1. **Temporary approach**: Set `ignore_schema_changes = false`, add attributes, apply, then set back to `true`
2. **Separate resources**: Use the `aws_cognito_user_pool_schema` resource for new attributes (AWS provider v5+)
3. **Recreation**: Destroy and recreate the user pool (⚠️ **destroys all user data**)

### 💡 **Best Practices**

- **🎯 NEW DEPLOYMENTS**: **Always use `ignore_schema_changes = true`** to prevent schema perpetual diffs from the start
- **Plan your schema carefully**: Schema attributes are immutable after creation
- **Use separate schema resources**: For maximum flexibility, consider using `aws_cognito_user_pool_schema` resources
- **Test thoroughly**: Always run `terraform plan` to verify expected behavior

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.95 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cognito_identity_provider.identity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_resource_server.resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool.pool_with_schema_ignore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_cognito_user_pool_ui_customization.default_ui_customization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization) | resource |
| [aws_cognito_user_pool_ui_customization.ui_customization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_create_user_config"></a> [admin\_create\_user\_config](#input\_admin\_create\_user\_config) | The configuration for AdminCreateUser requests | `map(any)` | `{}` | no |
| <a name="input_admin_create_user_config_allow_admin_create_user_only"></a> [admin\_create\_user\_config\_allow\_admin\_create\_user\_only](#input\_admin\_create\_user\_config\_allow\_admin\_create\_user\_only) | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `true` | no |
| <a name="input_admin_create_user_config_email_message"></a> [admin\_create\_user\_config\_email\_message](#input\_admin\_create\_user\_config\_email\_message) | The message template for email messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"{username}, your verification code is `{####}`"` | no |
| <a name="input_admin_create_user_config_email_subject"></a> [admin\_create\_user\_config\_email\_subject](#input\_admin\_create\_user\_config\_email\_subject) | The subject line for email messages | `string` | `"Your verification code"` | no |
| <a name="input_admin_create_user_config_sms_message"></a> [admin\_create\_user\_config\_sms\_message](#input\_admin\_create\_user\_config\_sms\_message) | - The message template for SMS messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"Your username is {username} and temporary password is `{####}`"` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list(string)` | `null` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | The attributes to be auto-verified. Possible values: email, phone\_number | `list(string)` | `[]` | no |
| <a name="input_client_access_token_validity"></a> [client\_access\_token\_validity](#input\_client\_access\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| <a name="input_client_allowed_oauth_flows"></a> [client\_allowed\_oauth\_flows](#input\_client\_allowed\_oauth\_flows) | The name of the application client | `list(string)` | `[]` | no |
| <a name="input_client_allowed_oauth_flows_user_pool_client"></a> [client\_allowed\_oauth\_flows\_user\_pool\_client](#input\_client\_allowed\_oauth\_flows\_user\_pool\_client) | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools | `bool` | `true` | no |
| <a name="input_client_allowed_oauth_scopes"></a> [client\_allowed\_oauth\_scopes](#input\_client\_allowed\_oauth\_scopes) | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin) | `list(string)` | `[]` | no |
| <a name="input_client_auth_session_validity"></a> [client\_auth\_session\_validity](#input\_client\_auth\_session\_validity) | Amazon Cognito creates a session token for each API request in an authentication flow. AuthSessionValidity is the duration, in minutes, of that session token. Your user pool native user must respond to each authentication challenge before the session expires. Valid values between 3 and 15. Default value is 3. | `number` | `3` | no |
| <a name="input_client_callback_urls"></a> [client\_callback\_urls](#input\_client\_callback\_urls) | List of allowed callback URLs for the identity providers | `list(string)` | `[]` | no |
| <a name="input_client_default_redirect_uri"></a> [client\_default\_redirect\_uri](#input\_client\_default\_redirect\_uri) | The default redirect URI. Must be in the list of callback URLs | `string` | `""` | no |
| <a name="input_client_enable_token_revocation"></a> [client\_enable\_token\_revocation](#input\_client\_enable\_token\_revocation) | Whether the client token can be revoked | `bool` | `true` | no |
| <a name="input_client_explicit_auth_flows"></a> [client\_explicit\_auth\_flows](#input\_client\_explicit\_auth\_flows) | List of authentication flows (ADMIN\_NO\_SRP\_AUTH, CUSTOM\_AUTH\_FLOW\_ONLY, USER\_PASSWORD\_AUTH) | `list(string)` | `[]` | no |
| <a name="input_client_generate_secret"></a> [client\_generate\_secret](#input\_client\_generate\_secret) | Should an application secret be generated | `bool` | `true` | no |
| <a name="input_client_id_token_validity"></a> [client\_id\_token\_validity](#input\_client\_id\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. Must be between 5 minutes and 1 day. Cannot be greater than refresh token expiration. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| <a name="input_client_logout_urls"></a> [client\_logout\_urls](#input\_client\_logout\_urls) | List of allowed logout URLs for the identity providers | `list(string)` | `[]` | no |
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | The name of the application client | `string` | `null` | no |
| <a name="input_client_prevent_user_existence_errors"></a> [client\_prevent\_user\_existence\_errors](#input\_client\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `null` | no |
| <a name="input_client_read_attributes"></a> [client\_read\_attributes](#input\_client\_read\_attributes) | List of user pool attributes the application client can read from | `list(string)` | `[]` | no |
| <a name="input_client_refresh_token_validity"></a> [client\_refresh\_token\_validity](#input\_client\_refresh\_token\_validity) | The time limit in days refresh tokens are valid for. Must be between 60 minutes and 3650 days. This value will be overridden if you have entered a value in `token_validity_units` | `number` | `30` | no |
| <a name="input_client_supported_identity_providers"></a> [client\_supported\_identity\_providers](#input\_client\_supported\_identity\_providers) | List of provider names for the identity providers that are supported on this client | `list(string)` | `[]` | no |
| <a name="input_client_token_validity_units"></a> [client\_token\_validity\_units](#input\_client\_token\_validity\_units) | Configuration block for units in which the validity times are represented in. Valid values for the following arguments are: `seconds`, `minutes`, `hours` or `days`. | `any` | <pre>{<br/>  "access_token": "minutes",<br/>  "id_token": "minutes",<br/>  "refresh_token": "days"<br/>}</pre> | no |
| <a name="input_client_write_attributes"></a> [client\_write\_attributes](#input\_client\_write\_attributes) | List of user pool attributes the application client can write to | `list(string)` | `[]` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | A container with the clients definitions | `any` | `[]` | no |
| <a name="input_default_ui_customization_css"></a> [default\_ui\_customization\_css](#input\_default\_ui\_customization\_css) | CSS file content for default UI customization | `string` | `null` | no |
| <a name="input_default_ui_customization_image_file"></a> [default\_ui\_customization\_image\_file](#input\_default\_ui\_customization\_image\_file) | Image file path for default UI customization | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`. | `string` | `"INACTIVE"` | no |
| <a name="input_device_configuration"></a> [device\_configuration](#input\_device\_configuration) | The configuration for the user pool's device tracking | `map(any)` | `{}` | no |
| <a name="input_device_configuration_challenge_required_on_new_device"></a> [device\_configuration\_challenge\_required\_on\_new\_device](#input\_device\_configuration\_challenge\_required\_on\_new\_device) | Indicates whether a challenge is required on a new device. Only applicable to a new device | `bool` | `null` | no |
| <a name="input_device_configuration_device_only_remembered_on_user_prompt"></a> [device\_configuration\_device\_only\_remembered\_on\_user\_prompt](#input\_device\_configuration\_device\_only\_remembered\_on\_user\_prompt) | If true, a device is only remembered on user prompt | `bool` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Cognito User Pool domain | `string` | `null` | no |
| <a name="input_domain_certificate_arn"></a> [domain\_certificate\_arn](#input\_domain\_certificate\_arn) | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain | `string` | `null` | no |
| <a name="input_domain_managed_login_version"></a> [domain\_managed\_login\_version](#input\_domain\_managed\_login\_version) | The version number of managed login for your domain. 1 for hosted UI (classic), 2 for the newer managed login | `number` | `1` | no |
| <a name="input_email_configuration"></a> [email\_configuration](#input\_email\_configuration) | The Email Configuration | `map(any)` | `{}` | no |
| <a name="input_email_configuration_configuration_set"></a> [email\_configuration\_configuration\_set](#input\_email\_configuration\_configuration\_set) | The name of the configuration set | `string` | `null` | no |
| <a name="input_email_configuration_email_sending_account"></a> [email\_configuration\_email\_sending\_account](#input\_email\_configuration\_email\_sending\_account) | Instruct Cognito to either use its built-in functional or Amazon SES to send out emails. Allowed values: `COGNITO_DEFAULT` or `DEVELOPER` | `string` | `"COGNITO_DEFAULT"` | no |
| <a name="input_email_configuration_from_email_address"></a> [email\_configuration\_from\_email\_address](#input\_email\_configuration\_from\_email\_address) | Sender's email address or sender's display name with their email address (e.g. `john@example.com`, `John Smith <john@example.com>` or `"John Smith Ph.D." <john@example.com>)`. Escaped double quotes are required around display names that contain certain characters as specified in RFC 5322 | `string` | `null` | no |
| <a name="input_email_configuration_reply_to_email_address"></a> [email\_configuration\_reply\_to\_email\_address](#input\_email\_configuration\_reply\_to\_email\_address) | The REPLY-TO email address | `string` | `""` | no |
| <a name="input_email_configuration_source_arn"></a> [email\_configuration\_source\_arn](#input\_email\_configuration\_source\_arn) | The ARN of the email source | `string` | `""` | no |
| <a name="input_email_mfa_configuration"></a> [email\_mfa\_configuration](#input\_email\_mfa\_configuration) | Configuration block for configuring email Multi-Factor Authentication (MFA) | <pre>object({<br/>    message = string<br/>    subject = string<br/>  })</pre> | `null` | no |
| <a name="input_email_verification_message"></a> [email\_verification\_message](#input\_email\_verification\_message) | A string representing the email verification message | `string` | `null` | no |
| <a name="input_email_verification_subject"></a> [email\_verification\_subject](#input\_email\_verification\_subject) | A string representing the email verification subject | `string` | `null` | no |
| <a name="input_enable_propagate_additional_user_context_data"></a> [enable\_propagate\_additional\_user\_context\_data](#input\_enable\_propagate\_additional\_user\_context\_data) | Enables the propagation of additional user context data | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Change to false to avoid deploying any resources | `bool` | `true` | no |
| <a name="input_identity_providers"></a> [identity\_providers](#input\_identity\_providers) | Cognito Pool Identity Providers | `list(any)` | `[]` | no |
| <a name="input_ignore_schema_changes"></a> [ignore\_schema\_changes](#input\_ignore\_schema\_changes) | Whether to ignore changes to Cognito User Pool schemas after creation. Set to true to prevent perpetual diffs when using custom schemas. This prevents AWS API errors since schema attributes cannot be modified or removed once created in Cognito. Due to Terraform limitations with conditional lifecycle blocks, this uses a dual-resource approach. Default is false for backward compatibility - set to true to enable the fix. | `bool` | `false` | no |
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | A container for the AWS Lambda triggers associated with the user pool | `any` | `{}` | no |
| <a name="input_lambda_config_create_auth_challenge"></a> [lambda\_config\_create\_auth\_challenge](#input\_lambda\_config\_create\_auth\_challenge) | The ARN of the lambda creating an authentication challenge. | `string` | `null` | no |
| <a name="input_lambda_config_custom_email_sender"></a> [lambda\_config\_custom\_email\_sender](#input\_lambda\_config\_custom\_email\_sender) | A custom email sender AWS Lambda trigger. | `any` | `{}` | no |
| <a name="input_lambda_config_custom_message"></a> [lambda\_config\_custom\_message](#input\_lambda\_config\_custom\_message) | A custom Message AWS Lambda trigger. | `string` | `null` | no |
| <a name="input_lambda_config_custom_sms_sender"></a> [lambda\_config\_custom\_sms\_sender](#input\_lambda\_config\_custom\_sms\_sender) | A custom SMS sender AWS Lambda trigger. | `any` | `{}` | no |
| <a name="input_lambda_config_define_auth_challenge"></a> [lambda\_config\_define\_auth\_challenge](#input\_lambda\_config\_define\_auth\_challenge) | Defines the authentication challenge. | `string` | `null` | no |
| <a name="input_lambda_config_kms_key_id"></a> [lambda\_config\_kms\_key\_id](#input\_lambda\_config\_kms\_key\_id) | The Amazon Resource Name of Key Management Service Customer master keys. Amazon Cognito uses the key to encrypt codes and temporary passwords sent to CustomEmailSender and CustomSMSSender. | `string` | `null` | no |
| <a name="input_lambda_config_post_authentication"></a> [lambda\_config\_post\_authentication](#input\_lambda\_config\_post\_authentication) | A post-authentication AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_post_confirmation"></a> [lambda\_config\_post\_confirmation](#input\_lambda\_config\_post\_confirmation) | A post-confirmation AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_authentication"></a> [lambda\_config\_pre\_authentication](#input\_lambda\_config\_pre\_authentication) | A pre-authentication AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_sign_up"></a> [lambda\_config\_pre\_sign\_up](#input\_lambda\_config\_pre\_sign\_up) | A pre-registration AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_token_generation"></a> [lambda\_config\_pre\_token\_generation](#input\_lambda\_config\_pre\_token\_generation) | (deprecated) Allow to customize identity token claims before token generation | `string` | `null` | no |
| <a name="input_lambda_config_pre_token_generation_config"></a> [lambda\_config\_pre\_token\_generation\_config](#input\_lambda\_config\_pre\_token\_generation\_config) | Allow to customize identity token claims before token generation | `any` | `{}` | no |
| <a name="input_lambda_config_user_migration"></a> [lambda\_config\_user\_migration](#input\_lambda\_config\_user\_migration) | The user migration Lambda config type | `string` | `null` | no |
| <a name="input_lambda_config_verify_auth_challenge_response"></a> [lambda\_config\_verify\_auth\_challenge\_response](#input\_lambda\_config\_verify\_auth\_challenge\_response) | Verifies the authentication challenge response | `string` | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| <a name="input_number_schemas"></a> [number\_schemas](#input\_number\_schemas) | A container with the number schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | A container for information about the user pool password policy | <pre>object({<br/>    minimum_length                   = number,<br/>    require_lowercase                = bool,<br/>    require_numbers                  = bool,<br/>    require_symbols                  = bool,<br/>    require_uppercase                = bool,<br/>    temporary_password_validity_days = number<br/>    password_history_size            = number<br/>  })</pre> | `null` | no |
| <a name="input_password_policy_minimum_length"></a> [password\_policy\_minimum\_length](#input\_password\_policy\_minimum\_length) | The minimum length of the password policy that you have set | `number` | `8` | no |
| <a name="input_password_policy_password_history_size"></a> [password\_policy\_password\_history\_size](#input\_password\_policy\_password\_history\_size) | The number of previous passwords that users are prevented from reusing | `number` | `0` | no |
| <a name="input_password_policy_require_lowercase"></a> [password\_policy\_require\_lowercase](#input\_password\_policy\_require\_lowercase) | Whether you have required users to use at least one lowercase letter in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_numbers"></a> [password\_policy\_require\_numbers](#input\_password\_policy\_require\_numbers) | Whether you have required users to use at least one number in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_symbols"></a> [password\_policy\_require\_symbols](#input\_password\_policy\_require\_symbols) | Whether you have required users to use at least one symbol in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_uppercase"></a> [password\_policy\_require\_uppercase](#input\_password\_policy\_require\_uppercase) | Whether you have required users to use at least one uppercase letter in their password | `bool` | `true` | no |
| <a name="input_password_policy_temporary_password_validity_days"></a> [password\_policy\_temporary\_password\_validity\_days](#input\_password\_policy\_temporary\_password\_validity\_days) | The minimum length of the password policy that you have set | `number` | `7` | no |
| <a name="input_recovery_mechanisms"></a> [recovery\_mechanisms](#input\_recovery\_mechanisms) | The list of Account Recovery Options | `list(any)` | `[]` | no |
| <a name="input_resource_server_identifier"></a> [resource\_server\_identifier](#input\_resource\_server\_identifier) | An identifier for the resource server | `string` | `null` | no |
| <a name="input_resource_server_name"></a> [resource\_server\_name](#input\_resource\_server\_name) | A name for the resource server | `string` | `null` | no |
| <a name="input_resource_server_scope_description"></a> [resource\_server\_scope\_description](#input\_resource\_server\_scope\_description) | The scope description | `string` | `null` | no |
| <a name="input_resource_server_scope_name"></a> [resource\_server\_scope\_name](#input\_resource\_server\_scope\_name) | The scope name | `string` | `null` | no |
| <a name="input_resource_servers"></a> [resource\_servers](#input\_resource\_servers) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | A container with the schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_sign_in_policy"></a> [sign\_in\_policy](#input\_sign\_in\_policy) | Configuration block for sign-in policy. Allows configuring additional sign-in mechanisms like OTP | <pre>object({<br/>    allowed_first_auth_factors = list(string)<br/>  })</pre> | `null` | no |
| <a name="input_sign_in_policy_allowed_first_auth_factors"></a> [sign\_in\_policy\_allowed\_first\_auth\_factors](#input\_sign\_in\_policy\_allowed\_first\_auth\_factors) | List of allowed first authentication factors. Valid values: PASSWORD, EMAIL\_OTP, SMS\_OTP | `list(string)` | `[]` | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | A string representing the SMS authentication message | `string` | `null` | no |
| <a name="input_sms_configuration"></a> [sms\_configuration](#input\_sms\_configuration) | The SMS Configuration | `map(any)` | `{}` | no |
| <a name="input_sms_configuration_external_id"></a> [sms\_configuration\_external\_id](#input\_sms\_configuration\_external\_id) | The external ID used in IAM role trust relationships | `string` | `""` | no |
| <a name="input_sms_configuration_sns_caller_arn"></a> [sms\_configuration\_sns\_caller\_arn](#input\_sms\_configuration\_sns\_caller\_arn) | The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume | `string` | `""` | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | A string representing the SMS verification message | `string` | `null` | no |
| <a name="input_software_token_mfa_configuration"></a> [software\_token\_mfa\_configuration](#input\_software\_token\_mfa\_configuration) | Configuration block for software token MFA (multifactor-auth). mfa\_configuration must also be enabled for this to work | `map(any)` | `{}` | no |
| <a name="input_software_token_mfa_configuration_enabled"></a> [software\_token\_mfa\_configuration\_enabled](#input\_software\_token\_mfa\_configuration\_enabled) | If true, and if mfa\_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled | `bool` | `false` | no |
| <a name="input_string_schemas"></a> [string\_schemas](#input\_string\_schemas) | A container with the string schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the User Pool | `map(string)` | `{}` | no |
| <a name="input_temporary_password_validity_days"></a> [temporary\_password\_validity\_days](#input\_temporary\_password\_validity\_days) | The user account expiration limit, in days, after which the account is no longer usable | `number` | `7` | no |
| <a name="input_user_attribute_update_settings"></a> [user\_attribute\_update\_settings](#input\_user\_attribute\_update\_settings) | Configuration block for user attribute update settings. Must contain key `attributes_require_verification_before_update` with list with only valid values of `email` and `phone_number` | `map(list(string))` | `null` | no |
| <a name="input_user_group_description"></a> [user\_group\_description](#input\_user\_group\_description) | The description of the user group | `string` | `null` | no |
| <a name="input_user_group_name"></a> [user\_group\_name](#input\_user\_group\_name) | The name of the user group | `string` | `null` | no |
| <a name="input_user_group_precedence"></a> [user\_group\_precedence](#input\_user\_group\_precedence) | The precedence of the user group | `number` | `null` | no |
| <a name="input_user_group_role_arn"></a> [user\_group\_role\_arn](#input\_user\_group\_role\_arn) | The ARN of the IAM role to be associated with the user group | `string` | `null` | no |
| <a name="input_user_groups"></a> [user\_groups](#input\_user\_groups) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_user_pool_add_ons"></a> [user\_pool\_add\_ons](#input\_user\_pool\_add\_ons) | Configuration block for user pool add-ons to enable user pool advanced security mode features | `map(any)` | `{}` | no |
| <a name="input_user_pool_add_ons_advanced_security_mode"></a> [user\_pool\_add\_ons\_advanced\_security\_mode](#input\_user\_pool\_add\_ons\_advanced\_security\_mode) | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | `null` | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | The name of the user pool | `string` | n/a | yes |
| <a name="input_user_pool_tier"></a> [user\_pool\_tier](#input\_user\_pool\_tier) | Cognito User Pool tier. Valid values: LITE, ESSENTIALS, PLUS. | `string` | `"ESSENTIALS"` | no |
| <a name="input_username_attributes"></a> [username\_attributes](#input\_username\_attributes) | Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes` | `list(string)` | `null` | no |
| <a name="input_username_configuration"></a> [username\_configuration](#input\_username\_configuration) | The Username Configuration. Setting `case_sensitive` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs | `map(any)` | `{}` | no |
| <a name="input_verification_message_template"></a> [verification\_message\_template](#input\_verification\_message\_template) | The verification message templates configuration | `map(any)` | `{}` | no |
| <a name="input_verification_message_template_default_email_option"></a> [verification\_message\_template\_default\_email\_option](#input\_verification\_message\_template\_default\_email\_option) | The default email option. Must be either `CONFIRM_WITH_CODE` or `CONFIRM_WITH_LINK`. Defaults to `CONFIRM_WITH_CODE` | `string` | `null` | no |
| <a name="input_verification_message_template_email_message"></a> [verification\_message\_template\_email\_message](#input\_verification\_message\_template\_email\_message) | The email message template for sending a confirmation code to the user, it must contain the `{####}` placeholder | `string` | `null` | no |
| <a name="input_verification_message_template_email_message_by_link"></a> [verification\_message\_template\_email\_message\_by\_link](#input\_verification\_message\_template\_email\_message\_by\_link) | The email message template for sending a confirmation link to the user, it must contain the `{##Click Here##}` placeholder | `string` | `null` | no |
| <a name="input_verification_message_template_email_subject"></a> [verification\_message\_template\_email\_subject](#input\_verification\_message\_template\_email\_subject) | The subject line for the email message template for sending a confirmation code to the user | `string` | `null` | no |
| <a name="input_verification_message_template_email_subject_by_link"></a> [verification\_message\_template\_email\_subject\_by\_link](#input\_verification\_message\_template\_email\_subject\_by\_link) | The subject line for the email message template for sending a confirmation link to the user | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the user pool |
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | The ids of the user pool clients |
| <a name="output_client_ids_map"></a> [client\_ids\_map](#output\_client\_ids\_map) | The ids map of the user pool clients |
| <a name="output_client_secrets"></a> [client\_secrets](#output\_client\_secrets) | The client secrets of the user pool clients |
| <a name="output_client_secrets_map"></a> [client\_secrets\_map](#output\_client\_secrets\_map) | The client secrets map of the user pool clients |
| <a name="output_creation_date"></a> [creation\_date](#output\_creation\_date) | The date the user pool was created |
| <a name="output_domain_app_version"></a> [domain\_app\_version](#output\_domain\_app\_version) | The app version |
| <a name="output_domain_aws_account_id"></a> [domain\_aws\_account\_id](#output\_domain\_aws\_account\_id) | The AWS account ID for the user pool owner |
| <a name="output_domain_cloudfront_distribution"></a> [domain\_cloudfront\_distribution](#output\_domain\_cloudfront\_distribution) | The name of the CloudFront distribution |
| <a name="output_domain_cloudfront_distribution_arn"></a> [domain\_cloudfront\_distribution\_arn](#output\_domain\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution |
| <a name="output_domain_cloudfront_distribution_zone_id"></a> [domain\_cloudfront\_distribution\_zone\_id](#output\_domain\_cloudfront\_distribution\_zone\_id) | The ZoneID of the CloudFront distribution |
| <a name="output_domain_s3_bucket"></a> [domain\_s3\_bucket](#output\_domain\_s3\_bucket) | The S3 bucket where the static files for this domain are stored |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx\_yyyyy |
| <a name="output_id"></a> [id](#output\_id) | The id of the user pool |
| <a name="output_last_modified_date"></a> [last\_modified\_date](#output\_last\_modified\_date) | The date the user pool was last modified |
| <a name="output_name"></a> [name](#output\_name) | The name of the user pool |
| <a name="output_resource_servers_scope_identifiers"></a> [resource\_servers\_scope\_identifiers](#output\_resource\_servers\_scope\_identifiers) | A list of all scopes configured in the format identifier/scope\_name |
| <a name="output_user_group_arns"></a> [user\_group\_arns](#output\_user\_group\_arns) | The ARNs of the user groups |
| <a name="output_user_group_ids"></a> [user\_group\_ids](#output\_user\_group\_ids) | The ids of the user groups |
| <a name="output_user_group_names"></a> [user\_group\_names](#output\_user\_group\_names) | The names of the user groups |
| <a name="output_user_groups_map"></a> [user\_groups\_map](#output\_user\_groups\_map) | A map of user group names to their properties |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Know issues
### Removing all lambda triggers
If you define lambda triggers using the `lambda_config` block or any `lambda_config_*` variable and you want to remove all triggers, define the lambda_config block with an empty map `{}` and apply the plan. Then comment the `lambda_config` block or define it as `null` and apply the plan again.

This is needed because all parameters for the `lambda_config` block are optional and keeping all block attributes empty or null forces to create a `lambda_config {}` block very time a plan/apply is run.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.95 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cognito_identity_provider.identity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_identity_provider) | resource |
| [aws_cognito_resource_server.resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |
| [aws_cognito_user_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) | resource |
| [aws_cognito_user_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool.pool_with_schema_ignore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_cognito_user_pool_ui_customization.default_ui_customization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization) | resource |
| [aws_cognito_user_pool_ui_customization.ui_customization](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_ui_customization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_create_user_config"></a> [admin\_create\_user\_config](#input\_admin\_create\_user\_config) | The configuration for AdminCreateUser requests | `map(any)` | `{}` | no |
| <a name="input_admin_create_user_config_allow_admin_create_user_only"></a> [admin\_create\_user\_config\_allow\_admin\_create\_user\_only](#input\_admin\_create\_user\_config\_allow\_admin\_create\_user\_only) | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `true` | no |
| <a name="input_admin_create_user_config_email_message"></a> [admin\_create\_user\_config\_email\_message](#input\_admin\_create\_user\_config\_email\_message) | The message template for email messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"{username}, your verification code is `{####}`"` | no |
| <a name="input_admin_create_user_config_email_subject"></a> [admin\_create\_user\_config\_email\_subject](#input\_admin\_create\_user\_config\_email\_subject) | The subject line for email messages | `string` | `"Your verification code"` | no |
| <a name="input_admin_create_user_config_sms_message"></a> [admin\_create\_user\_config\_sms\_message](#input\_admin\_create\_user\_config\_sms\_message) | - The message template for SMS messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"Your username is {username} and temporary password is `{####}`"` | no |
| <a name="input_alias_attributes"></a> [alias\_attributes](#input\_alias\_attributes) | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list(string)` | `null` | no |
| <a name="input_auto_verified_attributes"></a> [auto\_verified\_attributes](#input\_auto\_verified\_attributes) | The attributes to be auto-verified. Possible values: email, phone\_number | `list(string)` | `[]` | no |
| <a name="input_client_access_token_validity"></a> [client\_access\_token\_validity](#input\_client\_access\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| <a name="input_client_allowed_oauth_flows"></a> [client\_allowed\_oauth\_flows](#input\_client\_allowed\_oauth\_flows) | The name of the application client | `list(string)` | `[]` | no |
| <a name="input_client_allowed_oauth_flows_user_pool_client"></a> [client\_allowed\_oauth\_flows\_user\_pool\_client](#input\_client\_allowed\_oauth\_flows\_user\_pool\_client) | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools | `bool` | `true` | no |
| <a name="input_client_allowed_oauth_scopes"></a> [client\_allowed\_oauth\_scopes](#input\_client\_allowed\_oauth\_scopes) | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin) | `list(string)` | `[]` | no |
| <a name="input_client_auth_session_validity"></a> [client\_auth\_session\_validity](#input\_client\_auth\_session\_validity) | Amazon Cognito creates a session token for each API request in an authentication flow. AuthSessionValidity is the duration, in minutes, of that session token. Your user pool native user must respond to each authentication challenge before the session expires. Valid values between 3 and 15. Default value is 3. | `number` | `3` | no |
| <a name="input_client_callback_urls"></a> [client\_callback\_urls](#input\_client\_callback\_urls) | List of allowed callback URLs for the identity providers | `list(string)` | `[]` | no |
| <a name="input_client_default_redirect_uri"></a> [client\_default\_redirect\_uri](#input\_client\_default\_redirect\_uri) | The default redirect URI. Must be in the list of callback URLs | `string` | `""` | no |
| <a name="input_client_enable_token_revocation"></a> [client\_enable\_token\_revocation](#input\_client\_enable\_token\_revocation) | Whether the client token can be revoked | `bool` | `true` | no |
| <a name="input_client_explicit_auth_flows"></a> [client\_explicit\_auth\_flows](#input\_client\_explicit\_auth\_flows) | List of authentication flows (ADMIN\_NO\_SRP\_AUTH, CUSTOM\_AUTH\_FLOW\_ONLY, USER\_PASSWORD\_AUTH) | `list(string)` | `[]` | no |
| <a name="input_client_generate_secret"></a> [client\_generate\_secret](#input\_client\_generate\_secret) | Should an application secret be generated | `bool` | `true` | no |
| <a name="input_client_id_token_validity"></a> [client\_id\_token\_validity](#input\_client\_id\_token\_validity) | Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. Must be between 5 minutes and 1 day. Cannot be greater than refresh token expiration. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| <a name="input_client_logout_urls"></a> [client\_logout\_urls](#input\_client\_logout\_urls) | List of allowed logout URLs for the identity providers | `list(string)` | `[]` | no |
| <a name="input_client_name"></a> [client\_name](#input\_client\_name) | The name of the application client | `string` | `null` | no |
| <a name="input_client_prevent_user_existence_errors"></a> [client\_prevent\_user\_existence\_errors](#input\_client\_prevent\_user\_existence\_errors) | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `null` | no |
| <a name="input_client_read_attributes"></a> [client\_read\_attributes](#input\_client\_read\_attributes) | List of user pool attributes the application client can read from | `list(string)` | `[]` | no |
| <a name="input_client_refresh_token_validity"></a> [client\_refresh\_token\_validity](#input\_client\_refresh\_token\_validity) | The time limit in days refresh tokens are valid for. Must be between 60 minutes and 3650 days. This value will be overridden if you have entered a value in `token_validity_units` | `number` | `30` | no |
| <a name="input_client_supported_identity_providers"></a> [client\_supported\_identity\_providers](#input\_client\_supported\_identity\_providers) | List of provider names for the identity providers that are supported on this client | `list(string)` | `[]` | no |
| <a name="input_client_token_validity_units"></a> [client\_token\_validity\_units](#input\_client\_token\_validity\_units) | Configuration block for units in which the validity times are represented in. Valid values for the following arguments are: `seconds`, `minutes`, `hours` or `days`. | `any` | <pre>{<br/>  "access_token": "minutes",<br/>  "id_token": "minutes",<br/>  "refresh_token": "days"<br/>}</pre> | no |
| <a name="input_client_write_attributes"></a> [client\_write\_attributes](#input\_client\_write\_attributes) | List of user pool attributes the application client can write to | `list(string)` | `[]` | no |
| <a name="input_clients"></a> [clients](#input\_clients) | A container with the clients definitions | `any` | `[]` | no |
| <a name="input_default_ui_customization_css"></a> [default\_ui\_customization\_css](#input\_default\_ui\_customization\_css) | CSS file content for default UI customization | `string` | `null` | no |
| <a name="input_default_ui_customization_image_file"></a> [default\_ui\_customization\_image\_file](#input\_default\_ui\_customization\_image\_file) | Image file path for default UI customization | `string` | `null` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature. Valid values are `ACTIVE` and `INACTIVE`. | `string` | `"INACTIVE"` | no |
| <a name="input_device_configuration"></a> [device\_configuration](#input\_device\_configuration) | The configuration for the user pool's device tracking | `map(any)` | `{}` | no |
| <a name="input_device_configuration_challenge_required_on_new_device"></a> [device\_configuration\_challenge\_required\_on\_new\_device](#input\_device\_configuration\_challenge\_required\_on\_new\_device) | Indicates whether a challenge is required on a new device. Only applicable to a new device | `bool` | `null` | no |
| <a name="input_device_configuration_device_only_remembered_on_user_prompt"></a> [device\_configuration\_device\_only\_remembered\_on\_user\_prompt](#input\_device\_configuration\_device\_only\_remembered\_on\_user\_prompt) | If true, a device is only remembered on user prompt | `bool` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Cognito User Pool domain | `string` | `null` | no |
| <a name="input_domain_certificate_arn"></a> [domain\_certificate\_arn](#input\_domain\_certificate\_arn) | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain | `string` | `null` | no |
| <a name="input_domain_managed_login_version"></a> [domain\_managed\_login\_version](#input\_domain\_managed\_login\_version) | The version number of managed login for your domain. 1 for hosted UI (classic), 2 for the newer managed login | `number` | `1` | no |
| <a name="input_email_configuration"></a> [email\_configuration](#input\_email\_configuration) | The Email Configuration | `map(any)` | `{}` | no |
| <a name="input_email_configuration_configuration_set"></a> [email\_configuration\_configuration\_set](#input\_email\_configuration\_configuration\_set) | The name of the configuration set | `string` | `null` | no |
| <a name="input_email_configuration_email_sending_account"></a> [email\_configuration\_email\_sending\_account](#input\_email\_configuration\_email\_sending\_account) | Instruct Cognito to either use its built-in functional or Amazon SES to send out emails. Allowed values: `COGNITO_DEFAULT` or `DEVELOPER` | `string` | `"COGNITO_DEFAULT"` | no |
| <a name="input_email_configuration_from_email_address"></a> [email\_configuration\_from\_email\_address](#input\_email\_configuration\_from\_email\_address) | Sender's email address or sender's display name with their email address (e.g. `john@example.com`, `John Smith <john@example.com>` or `"John Smith Ph.D." <john@example.com>)`. Escaped double quotes are required around display names that contain certain characters as specified in RFC 5322 | `string` | `null` | no |
| <a name="input_email_configuration_reply_to_email_address"></a> [email\_configuration\_reply\_to\_email\_address](#input\_email\_configuration\_reply\_to\_email\_address) | The REPLY-TO email address | `string` | `""` | no |
| <a name="input_email_configuration_source_arn"></a> [email\_configuration\_source\_arn](#input\_email\_configuration\_source\_arn) | The ARN of the email source | `string` | `""` | no |
| <a name="input_email_mfa_configuration"></a> [email\_mfa\_configuration](#input\_email\_mfa\_configuration) | Configuration block for configuring email Multi-Factor Authentication (MFA) | <pre>object({<br/>    message = string<br/>    subject = string<br/>  })</pre> | `null` | no |
| <a name="input_email_verification_message"></a> [email\_verification\_message](#input\_email\_verification\_message) | A string representing the email verification message | `string` | `null` | no |
| <a name="input_email_verification_subject"></a> [email\_verification\_subject](#input\_email\_verification\_subject) | A string representing the email verification subject | `string` | `null` | no |
| <a name="input_enable_propagate_additional_user_context_data"></a> [enable\_propagate\_additional\_user\_context\_data](#input\_enable\_propagate\_additional\_user\_context\_data) | Enables the propagation of additional user context data | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Change to false to avoid deploying any resources | `bool` | `true` | no |
| <a name="input_identity_providers"></a> [identity\_providers](#input\_identity\_providers) | Cognito Pool Identity Providers | `list(any)` | `[]` | no |
| <a name="input_ignore_schema_changes"></a> [ignore\_schema\_changes](#input\_ignore\_schema\_changes) | Whether to ignore changes to Cognito User Pool schemas after creation. Set to true to prevent perpetual diffs when using custom schemas. This prevents AWS API errors since schema attributes cannot be modified or removed once created in Cognito. Due to Terraform limitations with conditional lifecycle blocks, this uses a dual-resource approach. Default is false for backward compatibility - set to true to enable the fix. | `bool` | `false` | no |
| <a name="input_lambda_config"></a> [lambda\_config](#input\_lambda\_config) | A container for the AWS Lambda triggers associated with the user pool | `any` | `{}` | no |
| <a name="input_lambda_config_create_auth_challenge"></a> [lambda\_config\_create\_auth\_challenge](#input\_lambda\_config\_create\_auth\_challenge) | The ARN of the lambda creating an authentication challenge. | `string` | `null` | no |
| <a name="input_lambda_config_custom_email_sender"></a> [lambda\_config\_custom\_email\_sender](#input\_lambda\_config\_custom\_email\_sender) | A custom email sender AWS Lambda trigger. | `any` | `{}` | no |
| <a name="input_lambda_config_custom_message"></a> [lambda\_config\_custom\_message](#input\_lambda\_config\_custom\_message) | A custom Message AWS Lambda trigger. | `string` | `null` | no |
| <a name="input_lambda_config_custom_sms_sender"></a> [lambda\_config\_custom\_sms\_sender](#input\_lambda\_config\_custom\_sms\_sender) | A custom SMS sender AWS Lambda trigger. | `any` | `{}` | no |
| <a name="input_lambda_config_define_auth_challenge"></a> [lambda\_config\_define\_auth\_challenge](#input\_lambda\_config\_define\_auth\_challenge) | Defines the authentication challenge. | `string` | `null` | no |
| <a name="input_lambda_config_kms_key_id"></a> [lambda\_config\_kms\_key\_id](#input\_lambda\_config\_kms\_key\_id) | The Amazon Resource Name of Key Management Service Customer master keys. Amazon Cognito uses the key to encrypt codes and temporary passwords sent to CustomEmailSender and CustomSMSSender. | `string` | `null` | no |
| <a name="input_lambda_config_post_authentication"></a> [lambda\_config\_post\_authentication](#input\_lambda\_config\_post\_authentication) | A post-authentication AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_post_confirmation"></a> [lambda\_config\_post\_confirmation](#input\_lambda\_config\_post\_confirmation) | A post-confirmation AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_authentication"></a> [lambda\_config\_pre\_authentication](#input\_lambda\_config\_pre\_authentication) | A pre-authentication AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_sign_up"></a> [lambda\_config\_pre\_sign\_up](#input\_lambda\_config\_pre\_sign\_up) | A pre-registration AWS Lambda trigger | `string` | `null` | no |
| <a name="input_lambda_config_pre_token_generation"></a> [lambda\_config\_pre\_token\_generation](#input\_lambda\_config\_pre\_token\_generation) | (deprecated) Allow to customize identity token claims before token generation | `string` | `null` | no |
| <a name="input_lambda_config_pre_token_generation_config"></a> [lambda\_config\_pre\_token\_generation\_config](#input\_lambda\_config\_pre\_token\_generation\_config) | Allow to customize identity token claims before token generation | `any` | `{}` | no |
| <a name="input_lambda_config_user_migration"></a> [lambda\_config\_user\_migration](#input\_lambda\_config\_user\_migration) | The user migration Lambda config type | `string` | `null` | no |
| <a name="input_lambda_config_verify_auth_challenge_response"></a> [lambda\_config\_verify\_auth\_challenge\_response](#input\_lambda\_config\_verify\_auth\_challenge\_response) | Verifies the authentication challenge response | `string` | `null` | no |
| <a name="input_mfa_configuration"></a> [mfa\_configuration](#input\_mfa\_configuration) | Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| <a name="input_number_schemas"></a> [number\_schemas](#input\_number\_schemas) | A container with the number schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_password_policy"></a> [password\_policy](#input\_password\_policy) | A container for information about the user pool password policy | <pre>object({<br/>    minimum_length                   = number,<br/>    require_lowercase                = bool,<br/>    require_numbers                  = bool,<br/>    require_symbols                  = bool,<br/>    require_uppercase                = bool,<br/>    temporary_password_validity_days = number<br/>    password_history_size            = number<br/>  })</pre> | `null` | no |
| <a name="input_password_policy_minimum_length"></a> [password\_policy\_minimum\_length](#input\_password\_policy\_minimum\_length) | The minimum length of the password policy that you have set | `number` | `8` | no |
| <a name="input_password_policy_password_history_size"></a> [password\_policy\_password\_history\_size](#input\_password\_policy\_password\_history\_size) | The number of previous passwords that users are prevented from reusing | `number` | `0` | no |
| <a name="input_password_policy_require_lowercase"></a> [password\_policy\_require\_lowercase](#input\_password\_policy\_require\_lowercase) | Whether you have required users to use at least one lowercase letter in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_numbers"></a> [password\_policy\_require\_numbers](#input\_password\_policy\_require\_numbers) | Whether you have required users to use at least one number in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_symbols"></a> [password\_policy\_require\_symbols](#input\_password\_policy\_require\_symbols) | Whether you have required users to use at least one symbol in their password | `bool` | `true` | no |
| <a name="input_password_policy_require_uppercase"></a> [password\_policy\_require\_uppercase](#input\_password\_policy\_require\_uppercase) | Whether you have required users to use at least one uppercase letter in their password | `bool` | `true` | no |
| <a name="input_password_policy_temporary_password_validity_days"></a> [password\_policy\_temporary\_password\_validity\_days](#input\_password\_policy\_temporary\_password\_validity\_days) | The minimum length of the password policy that you have set | `number` | `7` | no |
| <a name="input_recovery_mechanisms"></a> [recovery\_mechanisms](#input\_recovery\_mechanisms) | The list of Account Recovery Options | `list(any)` | `[]` | no |
| <a name="input_resource_server_identifier"></a> [resource\_server\_identifier](#input\_resource\_server\_identifier) | An identifier for the resource server | `string` | `null` | no |
| <a name="input_resource_server_name"></a> [resource\_server\_name](#input\_resource\_server\_name) | A name for the resource server | `string` | `null` | no |
| <a name="input_resource_server_scope_description"></a> [resource\_server\_scope\_description](#input\_resource\_server\_scope\_description) | The scope description | `string` | `null` | no |
| <a name="input_resource_server_scope_name"></a> [resource\_server\_scope\_name](#input\_resource\_server\_scope\_name) | The scope name | `string` | `null` | no |
| <a name="input_resource_servers"></a> [resource\_servers](#input\_resource\_servers) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | A container with the schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_sms_authentication_message"></a> [sms\_authentication\_message](#input\_sms\_authentication\_message) | A string representing the SMS authentication message | `string` | `null` | no |
| <a name="input_sms_configuration"></a> [sms\_configuration](#input\_sms\_configuration) | The SMS Configuration | `map(any)` | `{}` | no |
| <a name="input_sms_configuration_external_id"></a> [sms\_configuration\_external\_id](#input\_sms\_configuration\_external\_id) | The external ID used in IAM role trust relationships | `string` | `""` | no |
| <a name="input_sms_configuration_sns_caller_arn"></a> [sms\_configuration\_sns\_caller\_arn](#input\_sms\_configuration\_sns\_caller\_arn) | The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume | `string` | `""` | no |
| <a name="input_sms_verification_message"></a> [sms\_verification\_message](#input\_sms\_verification\_message) | A string representing the SMS verification message | `string` | `null` | no |
| <a name="input_software_token_mfa_configuration"></a> [software\_token\_mfa\_configuration](#input\_software\_token\_mfa\_configuration) | Configuration block for software token MFA (multifactor-auth). mfa\_configuration must also be enabled for this to work | `map(any)` | `{}` | no |
| <a name="input_software_token_mfa_configuration_enabled"></a> [software\_token\_mfa\_configuration\_enabled](#input\_software\_token\_mfa\_configuration\_enabled) | If true, and if mfa\_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled | `bool` | `false` | no |
| <a name="input_string_schemas"></a> [string\_schemas](#input\_string\_schemas) | A container with the string schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the User Pool | `map(string)` | `{}` | no |
| <a name="input_temporary_password_validity_days"></a> [temporary\_password\_validity\_days](#input\_temporary\_password\_validity\_days) | The user account expiration limit, in days, after which the account is no longer usable | `number` | `7` | no |
| <a name="input_user_attribute_update_settings"></a> [user\_attribute\_update\_settings](#input\_user\_attribute\_update\_settings) | Configuration block for user attribute update settings. Must contain key `attributes_require_verification_before_update` with list with only valid values of `email` and `phone_number` | `map(list(string))` | `null` | no |
| <a name="input_user_group_description"></a> [user\_group\_description](#input\_user\_group\_description) | The description of the user group | `string` | `null` | no |
| <a name="input_user_group_name"></a> [user\_group\_name](#input\_user\_group\_name) | The name of the user group | `string` | `null` | no |
| <a name="input_user_group_precedence"></a> [user\_group\_precedence](#input\_user\_group\_precedence) | The precedence of the user group | `number` | `null` | no |
| <a name="input_user_group_role_arn"></a> [user\_group\_role\_arn](#input\_user\_group\_role\_arn) | The ARN of the IAM role to be associated with the user group | `string` | `null` | no |
| <a name="input_user_groups"></a> [user\_groups](#input\_user\_groups) | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| <a name="input_user_pool_add_ons"></a> [user\_pool\_add\_ons](#input\_user\_pool\_add\_ons) | Configuration block for user pool add-ons to enable user pool advanced security mode features | `map(any)` | `{}` | no |
| <a name="input_user_pool_add_ons_advanced_security_mode"></a> [user\_pool\_add\_ons\_advanced\_security\_mode](#input\_user\_pool\_add\_ons\_advanced\_security\_mode) | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | `null` | no |
| <a name="input_user_pool_name"></a> [user\_pool\_name](#input\_user\_pool\_name) | The name of the user pool | `string` | n/a | yes |
| <a name="input_user_pool_tier"></a> [user\_pool\_tier](#input\_user\_pool\_tier) | Cognito User Pool tier. Valid values: LITE, ESSENTIALS, PLUS. | `string` | `"ESSENTIALS"` | no |
| <a name="input_username_attributes"></a> [username\_attributes](#input\_username\_attributes) | Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes` | `list(string)` | `null` | no |
| <a name="input_username_configuration"></a> [username\_configuration](#input\_username\_configuration) | The Username Configuration. Setting `case_sensitive` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs | `map(any)` | `{}` | no |
| <a name="input_verification_message_template"></a> [verification\_message\_template](#input\_verification\_message\_template) | The verification message templates configuration | `map(any)` | `{}` | no |
| <a name="input_verification_message_template_default_email_option"></a> [verification\_message\_template\_default\_email\_option](#input\_verification\_message\_template\_default\_email\_option) | The default email option. Must be either `CONFIRM_WITH_CODE` or `CONFIRM_WITH_LINK`. Defaults to `CONFIRM_WITH_CODE` | `string` | `null` | no |
| <a name="input_verification_message_template_email_message"></a> [verification\_message\_template\_email\_message](#input\_verification\_message\_template\_email\_message) | The email message template for sending a confirmation code to the user, it must contain the `{####}` placeholder | `string` | `null` | no |
| <a name="input_verification_message_template_email_message_by_link"></a> [verification\_message\_template\_email\_message\_by\_link](#input\_verification\_message\_template\_email\_message\_by\_link) | The email message template for sending a confirmation link to the user, it must contain the `{##Click Here##}` placeholder | `string` | `null` | no |
| <a name="input_verification_message_template_email_subject"></a> [verification\_message\_template\_email\_subject](#input\_verification\_message\_template\_email\_subject) | The subject line for the email message template for sending a confirmation code to the user | `string` | `null` | no |
| <a name="input_verification_message_template_email_subject_by_link"></a> [verification\_message\_template\_email\_subject\_by\_link](#input\_verification\_message\_template\_email\_subject\_by\_link) | The subject line for the email message template for sending a confirmation link to the user | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the user pool |
| <a name="output_client_ids"></a> [client\_ids](#output\_client\_ids) | The ids of the user pool clients |
| <a name="output_client_ids_map"></a> [client\_ids\_map](#output\_client\_ids\_map) | The ids map of the user pool clients |
| <a name="output_client_secrets"></a> [client\_secrets](#output\_client\_secrets) | The client secrets of the user pool clients |
| <a name="output_client_secrets_map"></a> [client\_secrets\_map](#output\_client\_secrets\_map) | The client secrets map of the user pool clients |
| <a name="output_creation_date"></a> [creation\_date](#output\_creation\_date) | The date the user pool was created |
| <a name="output_domain_app_version"></a> [domain\_app\_version](#output\_domain\_app\_version) | The app version |
| <a name="output_domain_aws_account_id"></a> [domain\_aws\_account\_id](#output\_domain\_aws\_account\_id) | The AWS account ID for the user pool owner |
| <a name="output_domain_cloudfront_distribution"></a> [domain\_cloudfront\_distribution](#output\_domain\_cloudfront\_distribution) | The name of the CloudFront distribution |
| <a name="output_domain_cloudfront_distribution_arn"></a> [domain\_cloudfront\_distribution\_arn](#output\_domain\_cloudfront\_distribution\_arn) | The ARN of the CloudFront distribution |
| <a name="output_domain_cloudfront_distribution_zone_id"></a> [domain\_cloudfront\_distribution\_zone\_id](#output\_domain\_cloudfront\_distribution\_zone\_id) | The ZoneID of the CloudFront distribution |
| <a name="output_domain_s3_bucket"></a> [domain\_s3\_bucket](#output\_domain\_s3\_bucket) | The S3 bucket where the static files for this domain are stored |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx\_yyyyy |
| <a name="output_id"></a> [id](#output\_id) | The id of the user pool |
| <a name="output_last_modified_date"></a> [last\_modified\_date](#output\_last\_modified\_date) | The date the user pool was last modified |
| <a name="output_name"></a> [name](#output\_name) | The name of the user pool |
| <a name="output_resource_servers_scope_identifiers"></a> [resource\_servers\_scope\_identifiers](#output\_resource\_servers\_scope\_identifiers) | A list of all scopes configured in the format identifier/scope\_name |
| <a name="output_user_group_arns"></a> [user\_group\_arns](#output\_user\_group\_arns) | The ARNs of the user groups |
| <a name="output_user_group_ids"></a> [user\_group\_ids](#output\_user\_group\_ids) | The ids of the user groups |
| <a name="output_user_group_names"></a> [user\_group\_names](#output\_user\_group\_names) | The names of the user groups |
| <a name="output_user_groups_map"></a> [user\_groups\_map](#output\_user\_groups\_map) | A map of user group names to their properties |
<!-- END_TF_DOCS -->
