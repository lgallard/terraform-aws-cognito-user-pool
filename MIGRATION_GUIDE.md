# User Groups Migration Guide

## Overview
This guide covers the migration from count-based to for_each-based user group implementation in the terraform-aws-cognito-user-pool module. This change resolves issue #161 where user groups were vulnerable to unintended deletion when list order changed.

## What Changed
- **Before**: User groups used `count` with list indexes as resource identifiers
- **After**: User groups use `for_each` with group names as stable resource identifiers

## Migration Process

### Manual Migration Required
Due to Terraform limitations with dynamic expressions in `moved` blocks, manual state migration is required.

### Steps to Upgrade

1. **Update the module version** in your Terraform configuration
2. **Run terraform plan** to see what changes Terraform wants to make
3. **Identify your existing user groups** from the plan output
4. **Run state migration commands** for each group:

```bash
# Example: If you have groups named "admins", "users", "developers"
terraform state mv 'aws_cognito_user_group.main[0]' 'aws_cognito_user_group.main["admins"]'
terraform state mv 'aws_cognito_user_group.main[1]' 'aws_cognito_user_group.main["users"]'
terraform state mv 'aws_cognito_user_group.main[2]' 'aws_cognito_user_group.main["developers"]'
```

5. **Run terraform plan again** to verify no changes are needed
6. **Run terraform apply** if any configuration changes are required

### What to Expect
- Initial `terraform plan` will show groups being destroyed and recreated
- After state migration, `terraform plan` should show no changes
- **No resources will be destroyed or recreated** when migration is done correctly
- Existing user group memberships are preserved

## Validation
After migration, you can verify:
- User groups still exist in the AWS console
- All group memberships are intact
- Group configurations remain unchanged

## New Features
- **List order immunity**: Reordering groups in configuration won't cause deletions
- **Unique name validation**: Duplicate group names are now prevented
- **Enhanced outputs**: New outputs for group IDs, names, ARNs, and detailed mapping

## Breaking Changes
- **None for existing configurations** - the migration is backward compatible
- **New validation**: Duplicate group names will now cause validation errors

## Troubleshooting

### Finding Your Group Names
To identify your current group names and their order:

```bash
# List current user groups in your state
terraform state list | grep aws_cognito_user_group
terraform state show 'aws_cognito_user_group.main[0]' | grep name
terraform state show 'aws_cognito_user_group.main[1]' | grep name
# ... continue for all groups
```

### Alternative Migration Approach
If you prefer to avoid manual state migration, you can:

1. **Export user memberships** before the change:
```bash
aws cognito-idp list-users-in-group --user-pool-id <pool_id> --group-name <group_name>
```

2. **Allow Terraform to recreate the groups** (they will be recreated with the same settings)

3. **Restore user memberships** after the change:
```bash
aws cognito-idp admin-add-user-to-group --user-pool-id <pool_id> --group-name <group_name> --username <username>
```

## Questions?
If you encounter issues during migration, please create an issue in the repository with:
- Your Terraform version
- Current module version
- Error messages
- Your user group configuration
