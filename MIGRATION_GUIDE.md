# Migration Guide

This guide covers migrations from count-based to for_each-based implementations in the terraform-aws-cognito-user-pool module.

## User Pool Clients Migration (PR #249)

### Overview
This guide covers the migration from count-based to for_each-based user pool client implementation. This change resolves state management issues and improves resource tracking.

### What Changed
- **Before**: User pool clients used `count` with list indexes as resource identifiers
- **After**: User pool clients use `for_each` with meaningful keys as stable resource identifiers

### Key Generation Pattern
The new for_each implementation uses the following key pattern:
```hcl
"${lookup(client, "name", "client")}_${idx}" => client
```

This means:
- Clients with names: `"my-app_0"`, `"mobile-client_1"`, etc.
- Clients without names: `"client_0"`, `"client_1"`, etc.

### Migration Process

#### Manual Migration Required
Due to Terraform limitations with dynamic expressions in `moved` blocks, manual state migration is required.

#### Steps to Upgrade

##### Option 1: Using the Migration Helper Script (Recommended)

1. **Update the module version** in your Terraform configuration
2. **Run the migration script**:
```bash
chmod +x migrate-clients.sh
./migrate-clients.sh
```

The script will:
- Analyze your current Terraform state
- Prompt you for client names
- Generate the correct migration commands
- Optionally run the commands automatically
- Verify the migration with `terraform plan`

##### Option 2: Manual Migration

1. **Update the module version** in your Terraform configuration
2. **Run terraform plan** to see what changes Terraform wants to make
3. **Identify your existing clients** from the plan output and your configuration
4. **Run state migration commands** for each client:

```bash
# Example 1: Clients with names
# Configuration: clients = [{ name = "web-app" }, { name = "mobile-app" }]
terraform state mv 'aws_cognito_user_pool_client.client[0]' 'aws_cognito_user_pool_client.client["web-app_0"]'
terraform state mv 'aws_cognito_user_pool_client.client[1]' 'aws_cognito_user_pool_client.client["mobile-app_1"]'

# Example 2: Clients without names
# Configuration: clients = [{}, {}] (no name specified)
terraform state mv 'aws_cognito_user_pool_client.client[0]' 'aws_cognito_user_pool_client.client["client_0"]'
terraform state mv 'aws_cognito_user_pool_client.client[1]' 'aws_cognito_user_pool_client.client["client_1"]'

# Example 3: Mixed configuration
# Configuration: clients = [{ name = "web-app" }, {}] (first has name, second doesn't)
terraform state mv 'aws_cognito_user_pool_client.client[0]' 'aws_cognito_user_pool_client.client["web-app_0"]'
terraform state mv 'aws_cognito_user_pool_client.client[1]' 'aws_cognito_user_pool_client.client["client_1"]'
```

5. **Run terraform plan again** to verify no changes are needed
6. **Run terraform apply** if any configuration changes are required

#### What to Expect
- Initial `terraform plan` will show clients being destroyed and recreated
- After state migration, `terraform plan` should show no changes
- **No resources will be destroyed or recreated** when migration is done correctly
- Existing client configurations and secrets are preserved

#### Validation
After migration, you can verify:
- User pool clients still exist in the AWS console
- All client configurations remain unchanged
- Client secrets are preserved (if they were generated)

#### New Features
- **List order immunity**: Reordering clients in configuration won't cause deletions
- **Better resource tracking**: More meaningful resource identifiers
- **Enhanced outputs**: Outputs now use client names as keys when available

#### Breaking Changes
- **None for existing configurations** - the migration is backward compatible
- Resource addresses change from indexed to named keys

#### Troubleshooting

##### Finding Your Client Names and Order
To identify your current client names and their order:

```bash
# List current clients in your state
terraform state list | grep aws_cognito_user_pool_client

# Show client details to find names
terraform state show 'aws_cognito_user_pool_client.client[0]' | grep name
terraform state show 'aws_cognito_user_pool_client.client[1]' | grep name
# ... continue for all clients
```

##### Alternative Migration Approach
If you prefer to avoid manual state migration:

1. **Backup client configurations** before the change:
```bash
# Export client settings
aws cognito-idp describe-user-pool-client --user-pool-id <pool_id> --client-id <client_id>
```

2. **Allow Terraform to recreate the clients** (they will be recreated with the same settings)
   - **Note**: Client secrets will be regenerated and need to be updated in applications

3. **Update applications** with new client secrets if `generate_secret = true`

---

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
