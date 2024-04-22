## 0.27.2 (April 22, 2024)

FIXES:

* Fix case when no `pre_token_generation_config` is present

## 0.27.1 (April 22, 2024)

FIXES:

* Fix dynamic `pre_token_generation_config` args (thanks @lgallard)

## 0.27.0 (April 22, 2024)

ENHANCEMENTS:

* Add `cloudfront_distribution_zone_id` attribute as output (thanks @catrielg)

FIXES:

* Fix support for pre token customization lambda V2 (thanks @Dogacel)

## 0.26.0 (March 22, 2024)

ENHANCEMENTS:

* Add ui customization for clients (thanks @DocMarten)

## 0.25.0 (February 17, 2024)

FIXES:

* Add back previously removed lifecyle ignore block (thanks @chris-symbiote)

## 0.24.0 (November 13, 2023)

FIXES:

*  Make sure `attribute_constraints` are created for string and number schemas (thanks @mhorbul)

## 0.23.0 (July 19, 2023)

ENHANCEMENTS:

* Add Cognito User Pool name as output (thanks @SlavaNL)

## 0.22.0 (March 31, 2023)

FIXES:

* Fix user attribute update settings lookup (thanks @trahim)

## 0.21.0 (January 6, 2023)

ENHANCEMENTS:

* Add support for `auth_session_validity` parameter to user pool client (thanks @xposix)

## 0.20.1 (November 24, 2022)

FIXES:

* Updated AWS provider minimum version to v4.38 as a requirement for `deletion_protection` (thanks @gchristidis)

## 0.20.0 (September 22, 2022)

ENHANCEMENTS:

* Add support for user pool deletion_protection (thanks @dmcgillen)
* Set `identity_providers` variable to `sensitive` (thanks @LawrenceWarren)

FIXES:

* Remove duplicate `require_lowercasei` key for password policies (thanks @jeromegamez)

## 0.19.0 (September 22, 2022)

FIXES:

* Fix the attributes constraints for number and string schemas (thanks @sgtoj)

## 0.18.2 (August 12, 2022)

FIXES:

* Fix ´username_configuration´ typo in README (thanks @ajoga and @KelvinVenancio)

## 0.18.1 (August 12, 2022)

ENHANCEMENTS:

* Add  0.13.7 as the lowest Terraform version supported (thanks @oleksiidv)

## 0.18.0 (July 25, 2022)

ENHANCEMENTS:

* Add missing option to allow client token revocation (thanks @rastakajakwanna)

## 0.17.0 (June 3, 2022)

ENHANCEMENTS:

* Add `configuration_set` field in `email_configuration` block (thanks @tiagoposse)

## 0.16.0 (May 30, 2022)

ENHANCEMENTS:

* Update complete example
* Update .pre-commit yaml file

FIXES:

* Fix `lambda_config` keeps changing

## 0.15.2 (February 19, 2022)

FIXES:

* Change aws provider version constraints to be able to use 4.x

## 0.15.1 (February 15, 2022)

FIXES:

* Change default value for `client_prevent_user_existence_errors` (thanks @juan-acevedo-ntt)

## 0.15.0 (February 12, 2022)

ENHANCEMENTS:

* Add custom sms and email sender support (thanks @xposix)

## 0.14.2 (September 20, 2021)

FIXES:

* Add identity provider as a dependency for `aws_cognito_user_pool_client` (thanks @xposix)

## 0.14.1 (August 25, 2021)

FIXES:

* Use accepted token validity periods (thanks @bobdoah)

## 0.14.0 (August 19, 2021)

ENHANCEMENTS:

* Add map output for client and secret ids (thanks @dmytro-dorofeiev)

## 0.13.0 (August 10, 2021)

ENHANCEMENTS:

* Add support for Cognito Identity Providers (thanks @bobdoah)

## 0.12.0 (July 4, 2021)

FIXES:

* Set client_secrets output to be sensitive (thanks @sapei)

## 0.11.1 (May 21, 2021)

FIXES:

* Revert prevent_destroy due to [Variables may not be used here issue](https://github.com/hashicorp/terraform/issues/22544)

## 0.11.0 (May 21, 2021)

ENHANCEMENTS:

* Add support to prevent the user pool from being destroyed (thanks @Waschnick)

## 0.10.5 (May 12, 2021)

FIXES:

* Fix incorrect example with `access_token_validity` (thanks @tsimbalar)

## 0.10.4 (April 25, 2021)

FIXES:

* Add `depends_on` servers in `aws_cognito_user_pool_client.client` resource

## 0.10.3 (April 15, 2021)

FIXES:

* Make code formatting works with Terraform >= 0.14 (Thanks @stevie-)

## 0.10.2 (April 10, 2021)

FIXES:

* Remove lifecycle for schema addition ([issue](https://github.com/hashicorp/terraform-provider-aws/pull/18512) fixed in the AWS provider)

## 0.10.1 (April 10, 2021)

FIXES:

* Update complete example

## 0.10.0 (April 10, 2021)

ENHANCEMENTS:

* Add support for `access_token_validity`, `id_token_validity` and `token_validity_units`
* Update complete example with `access_token_validity`, `id_token_validity` and `token_validity_units`

## 0.9.4 (February 14, 2021)

FIXES:

* Update README to include schema changes know issue

## 0.9.3 (January 27, 2021)

ENHANCEMENTS:

* Update description for `enabled` variable


## 0.9.2 (January 27, 2021)

ENHANCEMENTS:

* Update conditional creation example

## 0.9.1 (January 27, 2021)

FIXES:

* Set default value for enable variable to `true`

## 0.9.0 (January 24, 2021)

ENHANCEMENTS:

* Support conditional creation (thanks @Necromancerx)

## 0.8.0 (December 28, 2020)

ENHANCEMENTS:

* Add support for support `account_recovery_setting`

## 0.7.1 (December 11, 2020)

FIXES:

* Ignore schema changes and prevent pool destruction

## 0.7.0 (November 25, 2020)

ENHANCEMENTS:

* Add `from_email_address`

## 0.6.2 (August 13, 2020)

FIXES:

* Update CHANGELOG

## 0.6.1 (August 13, 2020)

ENHANCEMENTS:

* Change source in examples to use Terraform format

FIXES:

* Add `username_configuration` dynamic block to avoid forcing a new resource when importing a user pool
* Remove `case_sensitive` variable. Use the `username_configuration` map variable to define the `case_sensitive` attribute

UPDATES:

* Updated README and examples

## 0.5.0 (July 31, 2020)

FIXES:

* Depcreate support to `unused_account_validity_days`
* Update README and examples removing any reference to the deprecated `unused_account_validity_days` field

## 0.4.0 (May 2, 2020)

ENHANCEMENTS:

* Add support for `software_token_mfa_configuration`

## 0.3.3 (April 24, 2020)

FIXES:

* Applies `case_sensitive` via `username_configuration`

## 0.3.2 (April 24, 2020)

UPDATE:

* Update README with `case_sensitive`

## 0.3.1 (April 24, 2020)

ENHANCEMENTS:

* Add `case_sensitive` for `aws_cognito_user_pool`

## 0.3.0 (April 1, 2020)

ENHANCEMENTS:

* Add `param client_prevent_user_existence_errors` for client

UPDATES:

* Add Terraform logo in README

## 0.2.2 (March 16, 2020)

FIXES:

* Fix typo in comments

## 0.2.1 (February 6, 2020)

BUG FIXES:

* Cognito unused_account_validity_days bug with 2.47:  The aws-provider reports the existence of the `unused_account_validity_days` even if it was never declared, automatically matching the new `temporary_password_validity_day`

## 0.2.0 (February 5, 2020)

UPDATES:

* AWS Provider 2.47.0: Deprecate unused_account_validity_days argument and add support for temporary_password_validity_days argument

## 0.1.0 (November 23, 2019)

FEATURES:

  * Module implementation
