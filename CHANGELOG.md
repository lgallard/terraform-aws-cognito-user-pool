## [0.40.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.39.3...0.40.0) (2025-07-05)


### Features

* support user pool tier option ([#199](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/199)) ([82fa069](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/82fa0695bcafe584e1cc317dd6cf9529e9872677))

## [2.3.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.2.0...2.3.0) (2025-09-28)


### Features

* add support for ALLOW_ADMIN_USER_PASSWORD_AUTH explicit auth flow ([#310](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/310)) ([0b73c64](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/0b73c643d72d600cd6cbccf2a3f7e3e61bd1ebcf))
* implement repository dispatch for branch-context codebot analysis ([41cc328](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/41cc328051c42df473c47758afd0b281ecf41a5a))
* replace complex debug workflow with clean codebot pattern ([#319](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/319)) ([c75246e](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/c75246e93bfecba3ad73c1a22c03e8982e4ce1cd))
* restore codebot modes with flexible [@codebot](https://github.com/codebot) and codebot triggers ([#321](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/321)) ([f5bc08f](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/f5bc08fcac771bfdcef1bcc056102f6791e7e32e))
* simplify codebot workflow with direct approach ([1230048](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/123004895ee0107942a10d18c2c819d2d0921125))


### Bug Fixes

* Add allowed_tools parameter required for Claude comment posting ([#326](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/326)) ([afa9839](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/afa9839bdcd59a7e27a2eb8fc4f5dd8260e30d7f))
* Add back allowed_tools parameter - confirmed it works in claude.yml ([#328](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/328)) ([343856c](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/343856c80053bae837812a80db17831c02435b76))
* add required GitHub commenting tools to codebot workflow ([#331](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/331)) ([ae772ef](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/ae772ef5c0010be2ade7fa368f549974e3a6ad68))
* Add write permissions for Claude Code Action to post comments ([#323](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/323)) ([1b743fb](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/1b743fb35d356d1078eb3a5a2d73da0defee90d5))
* correct Claude Code Action parameters for codebot commenting ([#333](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/333)) ([e2d7980](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/e2d798015334e9da8ed4ff6f7dd615b6f4164b7a))
* correct MCP server tool names in GitHub Actions workflows ([#335](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/335)) ([f204d78](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/f204d78a12738eaac5497924032eb97db04c4f3d))
* critical codebot trigger and permissions fixes ([#320](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/320)) ([dac5127](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/dac51272a1ad70d7d9b539563a25f82e4a6e6ac5))
* Remove trigger_phrase that prevents Claude comment posting ([#325](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/325)) ([5a31b97](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/5a31b977a7fa05831465695867b9bba42e93e155))
* Remove unsupported allowed_tools parameter from Claude Code Action v1.0.0 ([#327](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/327)) ([1af03bf](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/1af03bfa4b365890952a7b4b278b1c4c4d86279d))
* resolve codebot workflow trigger and eyes emoji issues ([#313](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/313)) ([bd9101b](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/bd9101bfdb8659b815bf529161b45990949500fc))
* separate token usage for PR info and repository dispatch ([#317](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/317)) ([5d340be](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/5d340be8237f879b4b2fc1a23dcac93e81624aae))
* update Claude Code Action parameters to correct format ([#311](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/311)) ([67d4fba](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/67d4fbaed040a9edfa0f1a955f747f51fec25b1d))
* Update codebot trigger phrase to support mode commands ([#322](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/322)) ([fac74e5](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/fac74e5a40698fe35e6afb95da0b392ba10fe42c))
* use claude_args instead of unrecognized allowed_tools parameter ([#334](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/334)) ([eaeea0e](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/eaeea0e569240d74673a28777720da27a8bbd06c))
* use CLAUDE_CODE_OAUTH_TOKEN for repository dispatch authentication ([#316](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/316)) ([0b0f1f5](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/0b0f1f56ea6c41c49b18a4ba1f13b33056dfac73))
* Use environment variable for comment body to prevent command injection ([#330](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/330)) ([613a3ac](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/613a3ac76792fb2c095e84ea552016459c7bd995))
* Use printf instead of echo for comment body parsing to prevent command execution ([#329](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/329)) ([55ae5a5](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/55ae5a545ae97e0ef64e3c651240973078d63951))

## [2.2.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.1.4...2.2.0) (2025-08-24)


### Features

* Add automated Cognito User Pool feature discovery system ([#303](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/303)) ([e400e56](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/e400e56140c56fcc45e838e54a22f35e792f00a3))

## [2.1.4](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.1.3...2.1.4) (2025-08-18)


### Bug Fixes

* correct typo and test fixture validation errors ([#301](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/301)) ([1ca8dbb](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/1ca8dbb22324ad676bb9cfdcd84c99952ef7382d))

## [2.1.3](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.1.2...2.1.3) (2025-08-18)


### Bug Fixes

* remove incorrect aws_cognito_user_pool_schema resource reference ([#298](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/298)) ([bb18757](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/bb1875702e9dec3b21d438d5af44ed837b6ba6bc))

## [2.1.2](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.1.1...2.1.2) (2025-08-17)


### Bug Fixes

* configure Renovate to prevent pre-release Go versions ([#294](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/294)) ([510ca9a](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/510ca9a84ddf0908b5adea9e41512703f6d4db04))

## [2.1.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.1.0...2.1.1) (2025-08-12)


### Bug Fixes

* add dot character to allowed character in domain variable ([#290](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/290)) ([545c76d](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/545c76db492360f44cb7eee28d9a56afe109cecf))

## [2.1.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/2.0.0...2.1.0) (2025-08-11)


### Features

* update AWS provider version constraints to &gt;= 6.0 ([#286](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/286)) ([2458255](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/24582557ea22ab6848df61161f90f563fda33f51))

## [2.0.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.14.0...2.0.0) (2025-08-10)


### ⚠ BREAKING CHANGES

* Updated AWS provider version constraint from >= 5.98 to >= 6.0 due to breaking changes in advanced_security_additional_flows syntax.

### Features

* Add comprehensive security input validations for Cognito User Pool ([#275](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/275)) ([5988346](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/59883460482cd9d3761eba0707b36a6f76c53947))


### Bug Fixes

* correct advanced_security_additional_flows syntax for AWS provider 6.x ([#278](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/278)) ([7c60edc](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/7c60edc5e66fed762bba75ef8509eacc2bb43d9c))

## [1.14.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.13.0...1.14.0) (2025-08-10)


### Features

* integrate specialized subagents with GitHub Actions workflows ([#273](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/273)) ([5da717f](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/5da717f59c3af40344df22f55e826848bf0b1502))

## [1.13.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.12.0...1.13.0) (2025-08-10)


### Features

* add comprehensive pre-commit workflow for automated code quality ([8c1cc44](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/8c1cc44861e4abfb8c79ac532225d6692befc86f))

## [1.12.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.11.1...1.12.0) (2025-08-09)


### Features

* add MCP server support for enhanced documentation access ([#267](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/267)) ([38f6ea1](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/38f6ea1c2deddf2566b0379852ddc84ce8483e07))

## [1.11.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.11.0...1.11.1) (2025-08-08)


### Bug Fixes

* correct advanced_security_additional_flows structure to use proper AWS provider block syntax ([#265](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/265)) ([5fca639](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/5fca6396d2f31591cfeececee7e58b67af47ded4))

## [1.11.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.10.0...1.11.0) (2025-08-07)


### Features

* add support for advanced_security_additional_flows in user_pool_add_ons ([#263](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/263)) ([91dc7ec](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/91dc7ec4892d0b6973305adb53990c2f9bdf63be))

## [1.10.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.9.0...1.10.0) (2025-08-07)


### Features

* add Claude dispatch workflow for repository events ([#260](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/260)) ([eff2b33](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/eff2b3394437ec08928349380823adca5eb7efc9))

## [1.9.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.8.0...1.9.0) (2025-08-05)


### ⚠ BREAKING CHANGES

* Client resource addresses have changed from count-based to for_each-based identifiers. Existing deployments require manual state migration to avoid resource recreation.

### Features

* migrate aws_cognito_user_pool_client from count to for_each pattern ([#249](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/249)) ([a5e82b9](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/a5e82b97f8d072c5337be57ec3b46f711372a77a))

## [1.8.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.7.0...1.8.0) (2025-08-02)


### Features

* complete verification message template support for SMS and email conflict resolution ([#255](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/255)) ([d3e0b74](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/d3e0b74a16da1b5afffd9faa4a3a7007e3860177))

## [1.7.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.6.0...1.7.0) (2025-07-30)


### Features

* replicate security-hardened Claude Code Review workflow with PR focus ([#253](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/253)) ([b6ba6d4](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/b6ba6d44da86f15370d3160d29a43e120c158c4a))

## [1.6.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.5.1...1.6.0) (2025-07-28)


### Features

* add pre-commit hooks for code quality and Cognito identity validation ([#251](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/251)) ([3e6b2b6](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/3e6b2b69a5fe81dcd4209bd6f8e0a76bf1635f83))

## [1.5.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.5.0...1.5.1) (2025-07-23)


### Bug Fixes

* standardize release-please configuration ([#247](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/247)) ([41df41e](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/41df41efc787915c2456fd3f98f7a33f0d01bdaf))

## [1.5.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.4.2...1.5.0) (2025-07-20)


### Features

* add renovate dependency management ([#240](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/240)) ([0eeb896](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/0eeb896259ee83bb8548309c919de38f8dddaec9))

## [1.4.2](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.4.1...1.4.2) (2025-07-20)


### Bug Fixes

* **examples:** improve with_branding example configuration and assets ([#238](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/238)) ([2616bc9](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/2616bc9c0f754d3f9ad7a428746651f759d665ab))

## [1.4.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.4.0...1.4.1) (2025-07-20)


### Bug Fixes

* add documentation for color_mode validation requirements ([#236](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/236)) ([2138649](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/2138649db5f0cdf56df2ac66dfb661cd6a7b1a5a))

## [1.4.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.3.0...1.4.0) (2025-07-20)


### Features

* Add comprehensive testing framework with Terratest ([#228](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/228)) ([14903b0](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/14903b0b476e969ce62e1db50c64cbeac1ad2cb1))

## [1.3.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.2.0...1.3.0) (2025-07-18)


### Features

* Add managed login branding support and update development guidelines ([#216](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/216)) ([d38d2cc](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/d38d2cc5e52ab73912d25330a1a0c89504e7ce01))

## [1.2.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.1.0...1.2.0) (2025-07-14)


### Features

* add support for managed login branding ([#212](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/212)) ([2fc7195](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/2fc7195c4367125ab316696bed7e30da40b72dfd))

## [1.1.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.0.1...1.1.0) (2025-07-10)


### Features

* add support for sign_in_policy configuration ([#210](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/210)) ([86501df](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/86501df69602b8574acb9ec9bca86d7172dfc4bd))

## [1.0.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/1.0.0...1.0.1) (2025-07-08)


### Bug Fixes

* resolve unsupported attribute error for user_groups_map ARN ([#206](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/206)) ([9d5a08d](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/9d5a08d1dfb40b18a0094f3585f8df2888ec19ee)), closes [#205](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/205)

## [1.0.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.40.0...1.0.0) (2025-07-06)


### ⚠ BREAKING CHANGES

* User group resource addresses have changed from count-based to for_each-based identifiers. Existing deployments require manual state migration to avoid resource recreation.

### Bug Fixes

* switch user groups from count to for_each to prevent unintended deletion ([#202](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/202)) ([1bc67f6](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/1bc67f63c42b95b595f51fab5e473e74e89f3f4b))

## [0.39.3](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.39.2...0.39.3) (2025-06-29)


### Bug Fixes

* resolve schema perpetual diff issue with ignore_schema_changes variable ([#195](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/195)) ([896a22b](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/896a22b9c1061084769b067f474daada079bc287))

## [0.39.2](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.39.1...0.39.2) (2025-06-29)


### Bug Fixes

* Add comprehensive release-please configuration to prevent "v" prefix in release titles ([#193](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/193)) ([1b13b71](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/1b13b717d22670d5d435de2fdf3495aaf183d05c))

## [0.39.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.39.0...0.39.1) (2025-06-27)


### Bug Fixes

* Remove "v" prefix from release-please release titles ([#189](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/189)) ([f703982](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/f703982bec73743b73b86d30f0902d0e426f4b1a))

## [0.39.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.38.2...0.39.0) (2025-06-27)


### Features

* Fix device_configuration perpetual drift when using explicit false values (release) ([#186](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/186)) ([17cb3ac](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/17cb3accac0bb5c211a128a76c0b8188576b7bf7))

## [0.38.2](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.38.1...0.38.2) (2025-06-21)


### Bug Fixes

* Fix email_configuration documentation to show all available attributes ([#181](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/181)) ([c0c441e](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/c0c441e469fd4e08ab418919f7ca1263b57dcb5e))

## [0.38.1](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.38.0...0.38.1) (2025-06-21)


### Bug Fixes

* SAML identity provider drift by ignoring AWS-managed ActiveEncryptionCertificate ([#176](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/176)) ([539a7db](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/539a7dbfefb73b71e39769361a9447e9be8be0c6))

## [0.38.0](https://github.com/lgallard/terraform-aws-cognito-user-pool/compare/0.37.0...0.38.0) (2025-06-21)


### Features

* Implement release-please for automated versioning without "v" prefix ([#178](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues/178)) ([820145d](https://github.com/lgallard/terraform-aws-cognito-user-pool/commit/820145de397e36f369c3d03dc5db6b8c3fae0382))

## 0.37.0 (June 7, 2025)

ENHANCEMENTS:

* Add support for custom verification message template `email_message` and `email_subject` for code verification (thanks @lgallard)

## 0.36.0 (May 29, 2025)

ENHANCEMENTS:

* Add support for `email_mfa_configuration` parameter (thanks @bsipiak)
* Add example for email MFA configuration (thanks @lgallard)

## 0.35.0 (May 14, 2025)

ENHANCEMENTS:

* Add variable to change hosting ui version  (thanks @thedomeffm)

## 0.34.0 (February 21, 2025)

ENHANCEMENTS:

* Add password history size feature (thanks @DocMarten)
* Update examples
* Rename `password_policy_password_history_size` variable (thanks @lgallard)

## 0.33.0 (November 22, 2024)

ENHANCEMENTS:

* Add Default UI customization (thanks @sp-lut)

## 0.32.0 (Oct 27, 2024)

ENHANCEMENTS:

* Add enable_propagate_additional_user_context_data (thanks @AzgadGZ-CH)

FIXES:

* Fix device_configuration perpetual in-place replacement (thanks @joelgaria)
* Added comment in the complete example regarding perpetual in-place replacements when using sensitive data in idnetity_provider resources

## 0.31.0 (Aug 09, 2024)

FIXES:

* Unable to have devices remembered and force MFA sign in every time (thanks @trahim)

## 0.30.0 (Jun 26, 2024)

ENHANCEMENTS:

* Add missing arguments for `verification_message_template` block (thanks @catrielg)

## 0.29.0 (April 30, 2024)

ENHANCEMENTS:

* Refactor `lambda_config`  (thanks @lgallard)

## 0.28.0 (April 30, 2024)

ENHANCEMENTS:

* Add domain `cloudfront_distribution` name attribute as output (thanks @julb)

## 0.27.3 (April 23, 2024)

FIXES:

* Fix lambda customization config not working (thanks @Dogacel)

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
