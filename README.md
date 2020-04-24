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

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name = "mypool"

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
```

### Example (complete)

This more complete example creates a AWS Cognito User Pool using a detailed configuration. Please check the example folder to get the example with all options:

```
module "aws_cognito_user_pool_complete" {

  source = "../modules/terraform-aws-cognito-user-pool"

  user_pool_name           = "mypool"
  alias_attributes         = ["email", "phone_number"]
  auto_verified_attributes = ["email"]

  admin_create_user_config = {
    unused_account_validity_days = 9
    email_subject                = "Here, your verification code baby"
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

  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }

```

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.54.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_create\_user\_config | The configuration for AdminCreateUser requests | `map` | `{}` | no |
| admin\_create\_user\_config\_allow\_admin\_create\_user\_only | Set to True if only the administrator is allowed to create user profiles. Set to False if users can sign themselves up via an app | `bool` | `true` | no |
| admin\_create\_user\_config\_email\_message | The message template for email messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"{username}, your verification code is `{####}`"` | no |
| admin\_create\_user\_config\_email\_subject | The subject line for email messages | `string` | `"Your verification code"` | no |
| admin\_create\_user\_config\_sms\_message | - The message template for SMS messages. Must contain `{username}` and `{####}` placeholders, for username and temporary password, respectively | `string` | `"Your username is {username} and temporary password is `{####}`"` | no |
| alias\_attributes | Attributes supported as an alias for this user pool. Possible values: phone\_number, email, or preferred\_username. Conflicts with `username_attributes` | `list` | n/a | yes |
| auto\_verified\_attributes | The attributes to be auto-verified. Possible values: email, phone\_number | `list` | `[]` | no |
| case\_sensitive | Specifies whether username case sensitivity will be applied for all users in the user pool through Cognito APIs | `bool` | `true` | no |
| client\_allowed\_oauth\_flows | The name of the application client | `list` | `[]` | no |
| client\_allowed\_oauth\_flows\_user\_pool\_client | Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools | `bool` | `true` | no |
| client\_allowed\_oauth\_scopes | List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin) | `list` | `[]` | no |
| client\_callback\_urls | List of allowed callback URLs for the identity providers | `list` | `[]` | no |
| client\_default\_redirect\_uri | The default redirect URI. Must be in the list of callback URLs | `string` | `""` | no |
| client\_explicit\_auth\_flows | List of authentication flows (ADMIN\_NO\_SRP\_AUTH, CUSTOM\_AUTH\_FLOW\_ONLY, USER\_PASSWORD\_AUTH) | `list` | `[]` | no |
| client\_generate\_secret | Should an application secret be generated | `bool` | `true` | no |
| client\_logout\_urls | List of allowed logout URLs for the identity providers | `list` | `[]` | no |
| client\_name | The name of the application client | `string` | n/a | yes |
| client\_prevent\_user\_existence\_errors | Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool. | `string` | `""` | no |
| client\_read\_attributes | List of user pool attributes the application client can read from | `list` | `[]` | no |
| client\_refresh\_token\_validity | The time limit in days refresh tokens are valid for | `number` | `30` | no |
| client\_supported\_identity\_providers | List of provider names for the identity providers that are supported on this client | `list` | `[]` | no |
| client\_write\_attributes | List of user pool attributes the application client can write to | `list` | `[]` | no |
| clients | A container with the clients definitions | `list` | `[]` | no |
| device\_configuration | The configuration for the user pool's device tracking | `map` | `{}` | no |
| device\_configuration\_challenge\_required\_on\_new\_device | Indicates whether a challenge is required on a new device. Only applicable to a new device | `bool` | `false` | no |
| device\_configuration\_device\_only\_remembered\_on\_user\_prompt | If true, a device is only remembered on user prompt | `bool` | `false` | no |
| domain | Cognito User Pool domain | `string` | n/a | yes |
| domain\_certificate\_arn | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain | `string` | n/a | yes |
| email\_configuration | The Email Configuration | `map` | `{}` | no |
| email\_configuration\_email\_sending\_account | Instruct Cognito to either use its built-in functional or Amazon SES to send out emails. Allowed values: `COGNITO_DEFAULT` or `DEVELOPER` | `string` | `"COGNITO_DEFAULT"` | no |
| email\_configuration\_reply\_to\_email\_address | The REPLY-TO email address | `string` | `""` | no |
| email\_configuration\_source\_arn | The ARN of the email source | `string` | `""` | no |
| email\_verification\_message | A string representing the email verification message | `string` | n/a | yes |
| email\_verification\_subject | A string representing the email verification subject | `string` | n/a | yes |
| lambda\_config | A container for the AWS Lambda triggers associated with the user pool | `map` | n/a | yes |
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
| number\_schemas | A container with the number schema attributes of a user pool. Maximum of 50 attributes | `list` | `[]` | no |
| password\_policy | A container for information about the user pool password policy | <pre>object({<br>    minimum_length    = number,<br>    require_lowercase = bool,<br>    require_lowercase = bool,<br>    require_numbers   = bool,<br>    require_symbols   = bool,<br>    require_uppercase = bool,<br>    temporary_password_validity_days = number    <br>  })</pre> | n/a | yes |
| password\_policy\_minimum\_length | The minimum length of the password policy that you have set | `number` | `8` | no |
| password\_policy\_require\_lowercase | Whether you have required users to use at least one lowercase letter in their password | `bool` | `true` | no |
| password\_policy\_require\_numbers | Whether you have required users to use at least one number in their password | `bool` | `true` | no |
| password\_policy\_require\_symbols | Whether you have required users to use at least one symbol in their password | `bool` | `true` | no |
| password\_policy\_require\_uppercase | Whether you have required users to use at least one uppercase letter in their password | `bool` | `true` | no |
| password\_policy\_temporary\_password\_validity\_days | The minimum length of the password policy that you have set | `number` | `7` | no |
| resource\_server\_identifier | An identifier for the resource server | `string` | n/a | yes |
| resource\_server\_name | A name for the resource server | `string` | n/a | yes |
| resource\_server\_scope\_description | The scope description | `string` | n/a | yes |
| resource\_server\_scope\_name | The scope name | `string` | n/a | yes |
| resource\_servers | A container with the user\_groups definitions | `list` | `[]` | no |
| schemas | A container with the schema attributes of a user pool. Maximum of 50 attributes | `list` | `[]` | no |
| sms\_authentication\_message | A string representing the SMS authentication message | `string` | n/a | yes |
| sms\_configuration | The SMS Configuration | `map` | `{}` | no |
| sms\_configuration\_external\_id | The external ID used in IAM role trust relationships | `string` | `""` | no |
| sms\_configuration\_sns\_caller\_arn | The ARN of the Amazon SNS caller. This is usually the IAM role that you've given Cognito permission to assume | `string` | `""` | no |
| sms\_verification\_message | A string representing the SMS verification message | `string` | n/a | yes |
| string\_schemas | A container with the string schema attributes of a user pool. Maximum of 50 attributes | `list` | `[]` | no |
| tags | A mapping of tags to assign to the User Pool | `map(string)` | `{}` | no |
| temporary\_password\_validity\_days | The user account expiration limit, in days, after which the account is no longer usable | `number` | `7` | no |
| user\_group\_description | The description of the user group | `string` | n/a | yes |
| user\_group\_name | The name of the user group | `string` | n/a | yes |
| user\_group\_precedence | The precedence of the user group | `number` | n/a | yes |
| user\_group\_role\_arn | The ARN of the IAM role to be associated with the user group | `string` | n/a | yes |
| user\_groups | A container with the user\_groups definitions | `list` | `[]` | no |
| user\_pool\_add\_ons | Configuration block for user pool add-ons to enable user pool advanced security mode features | `map` | `{}` | no |
| user\_pool\_add\_ons\_advanced\_security\_mode | The mode for advanced security, must be one of `OFF`, `AUDIT` or `ENFORCED` | `string` | n/a | yes |
| user\_pool\_name | The name of the user pool | `string` | n/a | yes |
| username\_attributes | Specifies whether email addresses or phone numbers can be specified as usernames when a user signs up. Conflicts with `alias_attributes` | `list` | n/a | yes |
| verification\_message\_template | The verification message templates configuration | `map` | `{}` | no |
| verification\_message\_template\_default\_email\_option | The default email option. Must be either `CONFIRM_WITH_CODE` or `CONFIRM_WITH_LINK`. Defaults to `CONFIRM_WITH_CODE` | `string` | n/a | yes |
| verification\_message\_template\_email\_message\_by\_link | The email message template for sending a confirmation link to the user, it must contain the `{##Click Here##}` placeholder | `string` | n/a | yes |
| verification\_message\_template\_email\_subject\_by\_link | The subject line for the email message template for sending a confirmation link to the user | `string` | n/a | yes |

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


## Know issue
###removing all lambda triggers

If you define lambda triggers using the `lambda_config` block or any `lambda_config_*` variable and you want to remove all triggers, define the lambda_config block with an empty map `{}` and apply the plan. Then comment the `lambda_config` block or define it as `null` and apply the plan again. 

This is needed because all paramters for the `lambda_config` block are optional and keeping all block attributes empty or null forces to create a `lambda_config {}` block very time a plan/apply is run.
