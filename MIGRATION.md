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

## ⚠️ Action required: documented defaults now match module code

> ⚠️ **Review these defaults before upgrading.** This release regenerates the README input table with current module defaults. The module code already used these defaults before this release, but the published README table was stale. If your configuration relied on the previously documented values, pin the variables explicitly before applying.

- `deletion_protection` is `"ACTIVE"` in module code. If you require destroy-friendly behavior, set `deletion_protection = "INACTIVE"` explicitly before destroying a user pool.
- `mfa_configuration` is `"OPTIONAL"` in module code. If you require MFA to remain disabled, set `mfa_configuration = "OFF"` explicitly.

Review your Terraform plan and pin these inputs explicitly if your intended behavior differs from the module defaults.

## ⚠️ Managed login branding moved from AWSCC to native AWS provider

Managed login branding now uses the native `hashicorp/aws` provider resource:

- old resource address: `awscc_cognito_managed_login_branding.branding`
- new resource address: `aws_cognito_managed_login_branding.branding`

The module input shape is intentionally preserved for compatibility. Existing `managed_login_branding` configurations can keep using `assets` with the singular `extension` attribute; the module maps those values to the native provider `asset` blocks internally.

### What changed

- The `awscc` provider is no longer required for managed login branding.
- `return_merged_resources` is retained as a legacy input for compatibility, but the native provider exposes merged Cognito defaults through the `settings_all` attribute instead.
- Outputs continue to expose `managed_login_branding_details`, `managed_login_branding`, and `managed_login_branding_ids`.
- The `managed_login_branding_details.configurations[*].assets` output key is preserved, but its value now comes from the native AWS provider `asset` block shape.

### Existing state migration

If you already applied managed login branding with an older module version, move or import state before applying the new version to avoid Terraform planning a replacement.

For each branding key, move the Terraform state address from the AWSCC resource to the native AWS resource. Replace `<your_module_name>` with your actual module block label and `"main"` with your branding map key:

```bash
terraform state mv \
  'module.<your_module_name>.awscc_cognito_managed_login_branding.branding["main"]' \
  'module.<your_module_name>.aws_cognito_managed_login_branding.branding["main"]'
```

If state move is not possible, import the native resource using the user pool ID and managed login branding ID separated by a comma:

```bash
terraform import \
  'module.<your_module_name>.aws_cognito_managed_login_branding.branding["main"]' \
  'us-east-1_AbCdEfGhI,<managed-login-branding-id>'
```

Then run `terraform plan` and confirm Terraform does not intend to recreate the branding resource.

### Migration Steps

#### 1. Update Your Provider Version

Update your Terraform configuration to require AWS provider 6.x:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}
```

#### 2. Update Your Module Version

Update to the latest module version in your configuration:

```hcl
module "cognito_user_pool" {
  source = "lgallard/cognito-user-pool/aws"
  version = "1.14.1"  # or latest version

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
Error: Module requires aws provider version >= 6.0
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
| 1.14.1+        | >= 6.0      | >= 1.3.0  |
| 1.14.0         | >= 5.98     | >= 1.3.0  |
| < 1.14.0       | >= 5.0      | >= 1.0    |

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
