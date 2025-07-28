# Terraform AWS Cognito User Pool Module - Development Guidelines

## Overview
This document outlines Terraform-specific development guidelines for the terraform-aws-cognito-user-pool module, focusing on best practices for AWS Cognito identity and access management infrastructure as code.

## Module Structure & Organization

### File Organization
- **main.tf** - Primary Cognito User Pool resource definitions and locals
- **variables.tf** - Input variable definitions with validation
- **outputs.tf** - Output value definitions
- **versions.tf** - Provider version constraints
- **client.tf** - Cognito User Pool client configurations
- **domain.tf** - User pool domain configurations
- **identity-provider.tf** - Identity provider configurations
- **managed-login-branding.tf** - Managed login branding configurations
- **resource-server.tf** - Resource server configurations
- **ui-customization.tf** - UI customization configurations
- **user-group.tf** - User group configurations

### Code Organization Principles
- Group related resources logically in separate files
- Use descriptive locals for complex expressions
- Maintain backward compatibility with existing variable names
- Keep validation logic close to variable definitions

## Terraform Best Practices

### Resource Creation Patterns
**Favor `for_each` over `count`** for resource creation:

```hcl
# Preferred: Using for_each
resource "aws_cognito_user_pool_client" "this" {
  for_each = var.enabled ? var.clients : {}

  name         = each.value.name
  user_pool_id = aws_cognito_user_pool.pool[0].id
  # ...
}

# Avoid: Using count when for_each is more appropriate
resource "aws_cognito_user_pool_client" "this" {
  count = var.enabled ? length(var.clients) : 0
  # ...
}
```

### Variables & Validation
Use validation blocks for critical inputs where appropriate:

```hcl
# Example: Basic validation for naming conventions
variable "user_pool_name" {
  description = "Name of the Cognito User Pool to create"
  type        = string
  default     = null

  validation {
    condition     = var.user_pool_name == null ? true : can(regex("^[0-9A-Za-z-_\\s]{1,128}$", var.user_pool_name))
    error_message = "The user_pool_name must be between 1 and 128 characters, contain only alphanumeric characters, spaces, hyphens, and underscores."
  }
}
```

### Locals Organization
Structure locals for clarity and reusability:

```hcl
locals {
  # Resource creation conditions
  should_create_pool   = var.enabled && var.user_pool_name != null
  should_create_domain = local.should_create_pool && var.domain != null

  # Data processing
  clients = concat(local.default_client, var.clients)

  # Validation helpers
  mfa_requirements_met = var.mfa_configuration != null && var.software_token_mfa_configuration != null
}
```

## Testing Requirements

### Test Coverage for New Features
**Write tests when adding new features:**
- Create corresponding test files in `test/` directory
- Add example configurations in `examples/` directory
- Use Terratest for integration testing
- Test both success and failure scenarios

### Test Coverage for Modifications
**Add tests when modifying functionalities (if missing):**
- Review existing test coverage before making changes
- Add missing tests for functionality being modified
- Ensure backward compatibility is tested
- Test edge cases and error conditions

### Testing Strategy
- Use Terratest for integration testing
- Include examples for common use cases
- Test resource creation and destruction
- Validate outputs and state consistency
- Test different input combinations

## Security Considerations

### General Security Practices
- Configure strong password policies and MFA requirements
- Follow principle of least privilege for IAM roles and policies
- Implement proper access controls for user pool clients
- Use secure defaults for authentication flows
- Enable account takeover prevention when appropriate
- Configure secure token expiration times

### Example Security Patterns
```hcl
# Example: Password policy validation (optional)
variable "password_policy" {
  description = "Password policy configuration for the user pool"
  type = object({
    minimum_length    = number
    require_lowercase = bool
    require_numbers   = bool
    require_symbols   = bool
    require_uppercase = bool
  })
  default = null

  validation {
    condition     = var.password_policy == null ? true : var.password_policy.minimum_length >= 6 && var.password_policy.minimum_length <= 99
    error_message = "Password minimum length must be between 6 and 99 characters."
  }
}
```

## Module Development Guidelines

### Backward Compatibility
- Maintain existing variable interfaces when possible
- Use deprecation warnings for old patterns
- Provide migration guidance for breaking changes
- Document version-specific changes

### Code Quality
- Run `terraform fmt` before committing
- Use `terraform validate` to check syntax
- Consider pre-commit hooks for automated checks
- Use consistent naming conventions

## Specific Module Patterns

### Multi-Selection Support
Handle different input formats gracefully:

```hcl
# Support both legacy and new client formats
client_configurations = flatten([
  var.client_configurations,
  [for client in try(tolist(var.clients), []) : try(client.configuration, [])],
  [for k, client in try(tomap(var.clients), {}) : try(client.configuration, [])],
  [for client in var.user_pool_clients : try(client.configuration, [])],
  [for pool in var.pools : flatten([for client in try(pool.clients, []) : try(client.configuration, [])])]
])
```

### Using for_each for Complex Resources
```hcl
# Example: Creating multiple user pool clients
resource "aws_cognito_user_pool_client" "this" {
  for_each = {
    for idx, client in var.user_pool_clients :
    "${client.name}_${idx}" => client
  }

  user_pool_id = aws_cognito_user_pool.pool[0].id
  name         = each.value.name

  dynamic "explicit_auth_flows" {
    for_each = each.value.explicit_auth_flows
    content {
      # auth flow configuration
    }
  }
}
```

## Development Workflow

### Pre-commit Requirements
- Run `terraform fmt` on modified files
- Execute `terraform validate`
- Run tests for affected functionality
- Consider running security scanning tools
- Update documentation for variable changes

### Release Management
- **DO NOT manually update CHANGELOG.md** - we use release-please for automated changelog generation
- Use conventional commit messages for proper release automation
- Follow semantic versioning principles in commit messages

### Documentation Standards
- Document all variables with clear descriptions
- Include examples for complex variable structures
- Update README.md for new features
- Let release-please handle version history

## Common Patterns to Consider

1. **Prefer for_each** - Use `for_each` over `count` for better resource management
2. **Test Coverage** - Write tests for new features and missing test coverage
3. **Flexible Inputs** - Support multiple input formats where reasonable
4. **Validation Balance** - Add validation where it prevents common errors
5. **Consistent Naming** - Follow established naming conventions
6. **Resource Management** - Handle resource creation conflicts gracefully
7. **Backward Compatibility** - Maintain compatibility when possible
8. **Security Defaults** - Use secure defaults where appropriate

## Provider Version Management

```hcl
# Example provider configuration
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}
```

*Note: Version constraints should be chosen based on actual requirements and compatibility needs.*
