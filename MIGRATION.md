# Migration Guide - AWS Provider 6.x

## ⚠️ BREAKING CHANGE: AWS Provider 6.x Required

This module now requires AWS Provider **6.0 or later** due to breaking changes in the `advanced_security_additional_flows` configuration syntax.

### What Changed

**AWS Provider 5.x** (deprecated syntax):
```hcl
user_pool_add_ons {
  advanced_security_mode              = "ENFORCED"
  advanced_security_additional_flows = var.advanced_security_additional_flows
}
```

**AWS Provider 6.x** (current syntax):
```hcl
user_pool_add_ons {
  advanced_security_mode = "ENFORCED"

  dynamic "advanced_security_additional_flows" {
    for_each = var.advanced_security_additional_flows != null ? [1] : []
    content {
      custom_auth_mode = var.advanced_security_additional_flows
    }
  }
}
```

## ⚠️ State note: UI customization for clients without names

This release fixes UI customization handling for clients without configured names. Named clients are unaffected.

For clients where `name` is omitted, the module now uses a deterministic fallback key/name such as `client_0`. Previous versions could fail during planning or silently skip the `aws_cognito_user_pool_ui_customization` resource.

For clients explicitly configured with `name = ""`, the module preserves the historical Terraform key shape such as `_0` to avoid unnecessary state address churn. The module now also sends a non-empty fallback name such as `_0` to Cognito for these clients because the AWS provider marks the client `name` argument as required. Review plans for a possible in-place name update on clients that previously used an explicit empty string.

After upgrading, review `terraform plan` carefully. Some configurations may now show net-new `aws_cognito_user_pool_ui_customization` resources because they were previously skipped. If you somehow have state for an old hyphenated UI customization address such as:

```hcl
module.<your_module_name>.aws_cognito_user_pool_ui_customization.ui_customization["client-0"]
```

and Terraform proposes recreation at:

```hcl
module.<your_module_name>.aws_cognito_user_pool_ui_customization.ui_customization["client_0"]
```

prefer a manual state move after reviewing the plan:

```bash
terraform state mv \
  'module.<your_module_name>.aws_cognito_user_pool_ui_customization.ui_customization["client-0"]' \
  'module.<your_module_name>.aws_cognito_user_pool_ui_customization.ui_customization["client_0"]'
```

This module release intentionally does not add static `moved` blocks for this edge case because the old hyphenated address was not a reliable, generally creatable state shape and Terraform `moved` blocks cannot express dynamic moves for arbitrary client indexes.

## ⚠️ Action required: documented defaults now match module code

> ⚠️ **Review these defaults before upgrading.** This release regenerates the README input table with current module defaults. The module code already used these defaults before this release, but the published README table was stale. If your configuration relied on the previously documented values, pin the variables explicitly before applying.

- `deletion_protection` is `"ACTIVE"` in module code. If you require destroy-friendly behavior, set `deletion_protection = "INACTIVE"` explicitly before destroying a user pool.
- `mfa_configuration` is `"OPTIONAL"` in module code. If you require MFA to remain disabled, set `mfa_configuration = "OFF"` explicitly.

Review your Terraform plan and pin these inputs explicitly if your intended behavior differs from the module defaults.

## ⚠️ Managed login branding moved from AWSCC to native AWS provider

Managed login branding now uses the native `hashicorp/aws` provider resource, introduced in AWS provider **6.12.0**. This raises the module's AWS provider floor and changes the shape of the managed login branding `assets` output, so consumers should treat this as a breaking migration and follow the steps below before applying:

- old resource address: `awscc_cognito_managed_login_branding.branding`
- new resource address: `aws_cognito_managed_login_branding.branding`

The module input shape is intentionally preserved for compatibility. Existing `managed_login_branding` configurations can keep using `assets` with the singular `extension` attribute; the module maps those values to the native provider `asset` blocks internally.

### What changed

- The `awscc` provider is no longer required for managed login branding after state migration is complete.
- `return_merged_resources` is retained as a legacy input for compatibility, but the native provider exposes merged Cognito defaults through the `settings_all` attribute instead.
- Outputs continue to expose `managed_login_branding_details`, `managed_login_branding`, and `managed_login_branding_ids`.
- The `managed_login_branding_details.configurations[*].assets` output key is preserved, but its value now comes from the native AWS provider `asset` block shape. This may affect callers that relied on the previous AWSCC list shape or index-based access.

### Existing state migration

If you already applied managed login branding with an older module version, move or import state before applying the new version to avoid Terraform planning a replacement.

> ⚠️ **Do not remove the `awscc` provider block from your root module until after `terraform state mv` is complete and `terraform plan` shows no branding changes.** Removing the provider first can leave the old AWSCC state entry orphaned or cause Terraform to plan a destroy/create replacement that temporarily removes branding from the hosted UI.

Recommended safe order:

1. Keep both `aws` and `awscc` provider blocks available in the root module.
2. Before applying the upgraded module, remove any `return_merged_resources = true` entries from `managed_login_branding`; the native AWS provider exposes effective merged defaults through `managed_login_branding_details.configurations[*].settings_all` instead.
3. Back up state before any state operation. Terraform state can contain sensitive values such as Cognito app client secrets, identity provider credentials, and Base64 asset bytes. Verify `*.tfstate` is ignored by version control before creating a local backup, never commit state backups, and prefer encrypting the backup when possible:

   ```bash
   terraform state pull | gpg --symmetric > pre-managed-login-branding-migration.tfstate.gpg
   ```

   If you create an unencrypted backup instead, protect it carefully and delete it after the migration is verified:

   ```bash
   terraform state pull > pre-managed-login-branding-migration.tfstate
   ```

4. Move each branding key from the AWSCC resource address to the native AWS resource address. Replace `<your_module_name>` with your actual module block label and `"main"` with your branding map key:

   ```bash
   terraform state mv \
     'module.<your_module_name>.awscc_cognito_managed_login_branding.branding["main"]' \
     'module.<your_module_name>.aws_cognito_managed_login_branding.branding["main"]'
   ```

5. Run `terraform plan` after each state move, especially when migrating multiple branding keys, to catch partial migrations early. The first plan after `state mv` may show asset block changes because the old AWSCC state used an `assets` list and the native AWS provider uses an `asset` set. That is expected; confirm Terraform does **not** plan a destroy/create replacement for the branding resource.
6. After all branding keys are moved and `terraform plan` shows no branding replacement, remove the `awscc` provider block from your root module.
7. Run `terraform init -upgrade` and `terraform plan` again to confirm the configuration is clean.
8. Remove local state backup files such as `.terraform.tfstate.backup` after confirming they are no longer needed. Do not commit state backups; they can contain Base64 asset bytes and other state data.

If state move is not possible, import the native resource using the user pool ID and managed login branding ID separated by a comma:

```bash
terraform import \
  'module.<your_module_name>.aws_cognito_managed_login_branding.branding["main"]' \
  'us-east-1_AbCdEfGhI,<managed-login-branding-id>'
```

Then run `terraform plan` and confirm Terraform does not intend to recreate the branding resource.

If you removed the `awscc` provider block before moving state and Terraform reports `Provider configuration not available`, temporarily restore the `awscc` provider block, run `terraform init`, then perform the `terraform state mv` steps above before removing `awscc` again.

### Output shape changes

The `managed_login_branding_details.configurations[*].assets` key is preserved, but it now reflects the native AWS provider `asset` set. Index-based access that worked with the old AWSCC list output will fail.

Before, with the AWSCC list shape:

```hcl
module.pool.managed_login_branding_details.configurations["main"].assets[0].bytes
```

After, use a `for` expression over the native provider set:

```hcl
[for a in module.pool.managed_login_branding_details.configurations["main"].assets : a.bytes if a.category == "FORM_LOGO"][0]
```

The deprecated `managed_login_branding` output also keeps its `id` key, but the value now comes from the native provider ID format rather than the previous AWSCC provider ID.

## Migration Steps

#### 1. Update Your Provider Version

Update your Terraform configuration to require AWS provider 6.12.0 or later:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.12.0"
    }
  }
}
```

#### 2. Update Your Module Version

Update to the latest module version in your configuration:

```hcl
module "cognito_user_pool" {
  source = "lgallard/cognito-user-pool/aws"
  version = "5.0.0"  # or latest version

  # Your existing configuration remains the same
  user_pool_name = "my-pool"
  # ... other settings
}
```

#### 3. Run Migration Commands

Execute the following steps to migrate:

```bash
# 1. Download the new provider version
terraform init -upgrade

# 2. Review the changes (should be minimal/none for most users)
terraform plan

# 3. Apply the changes
terraform apply
```

### What to Expect

#### For Most Users
- **No configuration changes required** - your module usage remains identical
- **No resource changes** - existing user pools will not be modified
- **Provider update only** - just need to upgrade AWS provider to 6.x

#### For Advanced Security Users
If you use `user_pool_add_ons_advanced_security_additional_flows`:

**Before (still works the same way):**
```hcl
module "cognito_user_pool" {
  source = "lgallard/cognito-user-pool/aws"

  user_pool_name = "my-pool"
  user_pool_add_ons_advanced_security_mode              = "ENFORCED"
  user_pool_add_ons_advanced_security_additional_flows = "AUDIT"
}
```

**After (identical configuration):**
```hcl
module "cognito_user_pool" {
  source = "lgallard/cognito-user-pool/aws"

  user_pool_name = "my-pool"
  user_pool_add_ons_advanced_security_mode              = "ENFORCED"
  user_pool_add_ons_advanced_security_additional_flows = "AUDIT"
}
```

### Troubleshooting

#### Error: "Module requires newer AWS provider"
```
Error: Module requires aws provider version >= 6.12.0
```

**Solution**: Update your provider constraint and run `terraform init -upgrade`.

#### Error: "Invalid argument - advanced_security_additional_flows"
This indicates you're still using AWS provider 5.x.

**Solution**:
1. Update provider version in your `versions.tf` or main configuration
2. Run `terraform init -upgrade`
3. Run `terraform plan` and `terraform apply`

#### Error: "Provider configuration not available"
**Solution**: Ensure your AWS provider is properly configured with valid credentials.

### Version Compatibility Matrix

| Module Version | AWS Provider | Terraform |
|----------------|-------------|-----------|
| 5.0.0+         | >= 6.12.0   | >= 1.3.0  |
| 4.1.2          | >= 6.0      | >= 1.3.0  |
| < 4.1.2        | >= 5.0      | >= 1.0    |

### Need Help?

If you encounter issues during migration:

1. **Review this guide** carefully
2. **Check provider versions** with `terraform version`
3. **Validate configuration** with `terraform validate`
4. **Open an issue** on [GitHub](https://github.com/lgallard/terraform-aws-cognito-user-pool/issues) with:
   - Your Terraform version
   - Your AWS provider version
   - Full error message
   - Minimal reproduction case

### AWS Provider 6.x Benefits

Upgrading to AWS provider 6.x provides:

- **Cleaner syntax** for Cognito advanced security
- **Better validation** of configuration parameters
- **Improved error messages** for troubleshooting
- **Latest AWS features** and service improvements
- **Bug fixes** and security updates
