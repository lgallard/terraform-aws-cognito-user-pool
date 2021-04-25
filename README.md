![Terraform](https://lgallardo.com/images/terraform.jpg)
# terraform-aws-cognito-user-pool

Terraform module to create [Amazon Cognito User Pools](https://aws.amazon.com/cognito/), configure its attributes and resources such as  **app clients**, **domain**, **resource servers**. Amazon Cognito User Pools provide a secure user directory that scales to hundreds of millions of users. As a fully managed service, User Pools are easy to set up without any worries about standing up server infrastructure.

## Usage

You can use this module to create a Cognito User Pool using the default values or use the detailed definition to set every aspect of the Cognito User Pool

Check the [examples](examples/) where you can see the **simple** example using the default values, the **simple_extended** version which adds  **app clients**, **domain**, **resource servers** resources, or the **complete** version with a detailed example.

### Example (simple)

This simple example creates a AWS Cognito User Pool with the default values:

```
module "aws_cognito_user_pool_simple" {

  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name = "mypool"

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
```

### Example (conditional creation)

If you need to create Cognito User Pool resources conditionally in ealierform  versions such as 0.11, 0,12 and 0.13 you can set the input variable `enabled` to false:

```
# This Cognito User Pool will not be created
module "aws_cognito_user_pool_conditional_creation" {

  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name = "conditional_user_pool"

  enabled = false

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

```
module "aws_cognito_user_pool_complete" {

  source  = "lgallard/cognito-user-pool/aws"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    email_subject = "Here, your verification code baby"
  }

  email_configuration = {
    email_sending_account  = "DEVELOPER"
    reply_to_email_address = "email@example.com"
    source_arn             = "arn:aws:ses:us-east-1:888888888888:identity/example.com"
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

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

```
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9 |
| aws | >= 2.54.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.54.0 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_cognito_resource_server](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) |
| [aws_cognito_user_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_group) |
| [aws_cognito_user_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) |
| [aws_cognito_user_pool_client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) |
| [aws_cognito_user_pool_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_create\_user\_config | The configuration for AdminCreateUser requests | `map(any)` | `{}` | no |
| admin\_create\_user\_config\_allow\_admin\_create\_user\_only | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `true` | no |
| admin\_create\_user\_config\_email\_message | The message template for email messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"{username}, your verification code is `{####}`"` | no |
| admin\_create\_user\_config\_email\_subject | The subject line for email messages | `string` | `"Your verification code"` | no |
| admin\_create\_user\_config\_sms\_message | - The message template for SMS messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"Your username is {username} and temporary password is `{####}`"` | no |
| alias\_attributes | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list(string)` | `null` | no |
| auto\_verified\_attributes | The attributes to be auto-verified. Possible values: email, phone\_number | `list(string)` | `[]` | no |
| client\_access\_token\_validity | Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| client\_allowed\_oauth\_flows | The name of the application client | `list(string)` | `[]` | no |
| client\_allowed\_oauth\_flows\_user\_pool\_client | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools | `bool` | `true` | no |
| client\_allowed\_oauth\_scopes | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin) | `list(string)` | `[]` | no |
| client\_callback\_urls | List of allowed callback URLs for the identity providers | `list(string)` | `[]` | no |
| client\_default\_redirect\_uri | The default redirect URI. Must be in the list of callback URLs | `string` | `""` | no |
| client\_explicit\_auth\_flows | List of authentication flows (ADMIN\_NO\_SRP\_AUTH, CUSTOM\_AUTH\_FLOW\_ONLY, USER\_PASSWORD\_AUTH) | `list(string)` | `[]` | no |
| client\_generate\_secret | Should an application secret be generated | `bool` | `true` | no |
| client\_id\_token\_validity | Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. Must be between 5 minutes and 1 day. Cannot be greater than refresh token expiration. This value will be overridden if you have entered a value in `token_validity_units`. | `number` | `60` | no |
| client\_logout\_urls | List of allowed logout URLs for the identity providers | `list(string)` | `[]` | no |
| client\_name | The name of the application client | `string` | `null` | no |
| client\_prevent\_user\_existence\_errors | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `""` | no |
| client\_read\_attributes | List of user pool attributes the application client can read from | `list(string)` | `[]` | no |
| client\_refresh\_token\_validity | The time limit in days refresh tokens are valid for. Must be between 60 minutes and 3650 days. This value will be overridden if you have entered a value in `token_validity_units` | `number` | `30` | no |
| client\_supported\_identity\_providers | List of provider names for the identity providers that are supported on this client | `list(string)` | `[]` | no |
| client\_token\_validity\_units | Configuration block for units in which the validity times are represented in. Valid values for the following arguments are: `seconds`, `minutes`, `hours` or `days`. | `any` | <pre>{<br>  "access_token": "hours",<br>  "id_token": "hours",<br>  "refresh_token": "days"<br>}</pre> | no |
| client\_write\_attributes | List of user pool attributes the application client can write to | `list(string)` | `[]` | no |
| clients | A container with the clients definitions | `any` | `[]` | no |
| device\_configuration | The configuration for the user pool's device tracking | `map(any)` | `{}` | no |
| device\_configuration\_challenge\_required\_on\_new\_device | Indicates whether a challenge is required on a new device. Only applicable to a new device | `bool` | `false` | no |
| device\_configuration\_device\_only\_remembered\_on\_user\_prompt | If true, a device is only remembered on user prompt | `bool` | `false` | no |
| domain | Cognito User Pool domain | `string` | `null` | no |
| domain\_certificate\_arn | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain | `string` | `null` | no |
| email\_configuration | The Email Configuration | `map(any)` | `{}` | no |
| email\_configuration\_email\_sending\_account | Instruct Cognito to either use its built-in functional or Amazon SES to send out emails. Allowed values: `COGNITO_DEFAULT` or `DEVELOPER` | `string` | `"COGNITO_DEFAULT"` | no |
| email\_configuration\_from\_email\_address | Sender’s email address or sender’s display name with their email address (e.g. `john@example.com`, `John Smith <john@example.com>` or `"John Smith Ph.D." <john@example.com>)`. Escaped double quotes are required around display names that contain certain characters as specified in RFC 5322 | `string` | `null` | no |
| email\_configuration\_reply\_to\_email\_address | The REPLY-TO email address | `string` | `""` | no |
| email\_configuration\_source\_arn | The ARN of the email source | `string` | `""` | no |
| email\_verification\_message | A string representing the email verification message | `string` | `null` | no |
| email\_verification\_subject | A string representing the email verification subject | `string` | `null` | no |
| enabled | Change to false to avoid deploying any resources | `bool` | `true` | no |
| lambda\_config | A container for the AWS Lambda triggers associated with the user pool | `map(any)` | `null` | no |
| lambda\_config\_create\_auth\_challenge | The ARN of the lambda creating an authentication challenge. | `string` | `""` | no |
| lambda\_config\_custom\_message | A custom Message AWS Lambda trigger. | `string` | `""` | no |
| lambda\_config\_define\_auth\_challenge | Defines the authentication challenge. | `string` | `""` | no |
| lambda\_config\_post\_authentication | A post-authentication AWS Lambda trigger | `string` | `""` | no |
| lambda\_config\_post\_confirmation | A post-confirmation AWS Lambda trigger | `string` | `""` | no |
| lambda\_config\_pre\_authentication | A pre-authentication AWS Lambda trigger | `string` | `""` | no |
| lambda\_config\_pre\_sign\_up | A pre-registration AWS Lambda trigger | `string` | `""` | no |
| lambda\_config\_pre\_token\_generation | Allow to customize identity token claims before token generation | `string` | `""` | no |
| lambda\_config\_user\_migration | The user migration Lambda config type | `string` | `""` | no |
| lambda\_config\_verify\_auth\_challenge\_response | Verifies the authentication challenge response | `string` | `""` | no |
| mfa\_configuration | Set to enable multi-factor authentication. Must be one of the following values (ON, OFF, OPTIONAL) | `string` | `"OFF"` | no |
| number\_schemas | A container with the number schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| password\_policy | A container for information about the user pool password policy | <pre>object({<br>    minimum_length                   = number,<br>    require_lowercase                = bool,<br>    require_lowercase                = bool,<br>    require_numbers                  = bool,<br>    require_symbols                  = bool,<br>    require_uppercase                = bool,<br>    temporary_password_validity_days = number<br>  })</pre> | `null` | no |
| password\_policy\_minimum\_length | The minimum length of the password policy that you have set | `number` | `8` | no |
| password\_policy\_require\_lowercase | Whether you have required users to use at least one lowercase letter in their password | `bool` | `true` | no |
| password\_policy\_require\_numbers | Whether you have required users to use at least one number in their password | `bool` | `true` | no |
| password\_policy\_require\_symbols | Whether you have required users to use at least one symbol in their password | `bool` | `true` | no |
| password\_policy\_require\_uppercase | Whether you have required users to use at least one uppercase letter in their password | `bool` | `true` | no |
| password\_policy\_temporary\_password\_validity\_days | The minimum length of the password policy that you have set | `number` | `7` | no |
| recovery\_mechanisms | The list of Account Recovery Options | `list(any)` | `[]` | no |
| resource\_server\_identifier | An identifier for the resource server | `string` | `null` | no |
| resource\_server\_name | A name for the resource server | `string` | `null` | no |
| resource\_server\_scope\_description | The scope description | `string` | `null` | no |
| resource\_server\_scope\_name | The scope name | `string` | `null` | no |
| resource\_servers | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| schemas | A container with the schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| sms\_authentication\_message | A string representing the SMS authentication message | `string` | `null` | no |
| sms\_configuration | The SMS Configuration | `map(any)` | `{}` | no |
| sms\_configuration\_external\_id | The external ID used in IAM role trust relationships | `string` | `""` | no |
| sms\_configuration\_sns\_caller\_arn | The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume | `string` | `""` | no |
| sms\_verification\_message | A string representing the SMS verification message | `string` | `null` | no |
| software\_token\_mfa\_configuration | Configuration block for software token MFA (multifactor-auth). mfa\_configuration must also be enabled for this to work | `map(any)` | `{}` | no |
| software\_token\_mfa\_configuration\_enabled | If true, and if mfa\_configuration is also enabled, multi-factor authentication by software TOTP generator will be enabled | `bool` | `false` | no |
| string\_schemas | A container with the string schema attributes of a user pool. Maximum of 50 attributes | `list(any)` | `[]` | no |
| tags | A mapping of tags to assign to the User Pool | `map(string)` | `{}` | no |
| temporary\_password\_validity\_days | The user account expiration limit, in days, after which the account is no longer usable | `number` | `7` | no |
| user\_group\_description | The description of the user group | `string` | `null` | no |
| user\_group\_name | The name of the user group | `string` | `null` | no |
| user\_group\_precedence | The precedence of the user group | `number` | `null` | no |
| user\_group\_role\_arn | The ARN of the IAM role to be associated with the user group | `string` | `null` | no |
| user\_groups | A container with the user\_groups definitions | `list(any)` | `[]` | no |
| user\_pool\_add\_ons | Configuration block for user pool add-ons to enable user pool advanced security mode features | `map(any)` | `{}` | no |
| user\_pool\_add\_ons\_advanced\_security\_mode | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | `null` | no |
| user\_pool\_name | The name of the user pool | `string` | n/a | yes |
| username\_attributes | Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes` | `list(string)` | `null` | no |
| username\_configuration | The Username Configuration. Seting `case_sesiteve` specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs | `map(any)` | `{}` | no |
| verification\_message\_template | The verification message templates configuration | `map(any)` | `{}` | no |
| verification\_message\_template\_default\_email\_option | The default email option. Must be either `CONFIRM_WITH_CODE` or `CONFIRM_WITH_LINK`. Defaults to `CONFIRM_WITH_CODE` | `string` | `null` | no |
| verification\_message\_template\_email\_message\_by\_link | The email message template for sending a confirmation link to the user, it must contain the `{##Click Here##}` placeholder | `string` | `null` | no |
| verification\_message\_template\_email\_subject\_by\_link | The subject line for the email message template for sending a confirmation link to the user | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the user pool |
| client\_ids | The ids of the user pool clients |
| client\_secrets | The client secrets of the user pool clients |
| creation\_date | The date the user pool was created |
| domain\_app\_version | The app version |
| domain\_aws\_account\_id | The AWS account ID for the user pool owner |
| domain\_cloudfront\_distribution\_arn | The ARN of the CloudFront distribution |
| domain\_s3\_bucket | The S3 bucket where the static files for this domain are stored |
| endpoint | The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx\_yyyyy |
| id | The id of the user pool |
| last\_modified\_date | The date the user pool was last modified |
| resource\_servers\_scope\_identifiers | A list of all scopes configured in the format identifier/scope\_name |

## Know issues
### Schema changes (adding attributes)
There's an [open issue](https://github.com/hashicorp/terraform-provider-aws/issues/3891) in the AWS provider. The issue is regarding new schema changings like adding new attributes, forces the pool recreation.

This module disabled  schema changes recognition in PR #28 through an ignore lifecycle to avoid this behavior, until there's an official fix in the AWS provider.

### Removing all lambda triggers
If you define lambda triggers using the `lambda_config` block or any `lambda_config_*` variable and you want to remove all triggers, define the lambda_config block with an empty map `{}` and apply the plan. Then comment the `lambda_config` block or define it as `null` and apply the plan again.

This is needed because all parameters for the `lambda_config` block are optional and keeping all block attributes empty or null forces to create a `lambda_config {}` block very time a plan/apply is run.
