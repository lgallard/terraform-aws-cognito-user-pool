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

## AI-Powered Validation Requirements

This module uses AI-powered validation through specialized Claude Code subagents instead of traditional automated tests. This approach provides comprehensive analysis of code quality, security, Terraform best practices, and module functionality.

### Validation Strategy

#### Specialized Subagents Available
The module is configured with the following specialized validation agents:

1. **terraform-cognito** - AWS Cognito User Pool specialist for Terraform infrastructure development
   - Validates Cognito resource configurations
   - Ensures AWS best practices for identity management
   - Reviews authentication and authorization patterns

2. **cognito-migration** - AWS Cognito upgrade and migration specialist
   - Validates backward compatibility
   - Reviews migration paths for breaking changes
   - Ensures smooth version upgrades

3. **module-documentation** - Documentation and example specialist
   - Validates example configurations
   - Reviews documentation completeness
   - Ensures examples follow best practices

4. **terraform-security** - Security analysis and hardening specialist
   - Performs security analysis of configurations
   - Reviews password policies, MFA settings
   - Validates access controls and encryption settings
   - Checks for security vulnerabilities and misconfigurations

### When to Request AI Validation

#### For New Features
**Request validation when adding new features:**
- Request analysis from `terraform-cognito` agent for resource implementation review
- Use `module-documentation` agent to validate examples and documentation
- Invoke `terraform-security` agent for security implications analysis
- Ask for comprehensive review covering functionality, security, and best practices

**Example request:**
```
@claude Please use the terraform-cognito and terraform-security agents to review
the new advanced security mode feature I just implemented. Validate the
implementation follows AWS best practices and check for any security concerns.
```

#### For Modifications
**Request validation when modifying existing functionality:**
- Use `cognito-migration` agent to verify backward compatibility
- Invoke `terraform-security` agent if changes affect security configurations
- Request `terraform-cognito` agent review for resource configuration changes
- Ask for edge case analysis and potential issues

**Example request:**
```
@claude I've modified the password policy configuration. Please use the
cognito-migration agent to verify backward compatibility and the
terraform-security agent to validate the security implications.
```

#### For Security-Critical Changes
**Always request security validation for:**
- Authentication flow modifications
- MFA configuration changes
- Password policy updates
- Token expiration settings
- IAM role and policy changes
- Account takeover prevention features

**Example request:**
```
@claude Use the terraform-security agent to perform a comprehensive security
analysis of the updated MFA configuration. Check for any security weaknesses
or misconfigurations.
```

### Validation Coverage Areas

The AI validation approach covers:

1. **Configuration Validation**
   - Terraform syntax and best practices
   - Resource relationships and dependencies
   - Variable validation and type checking
   - Output definitions and data flows

2. **Security Analysis**
   - Security misconfigurations
   - Access control weaknesses
   - Encryption and data protection
   - Authentication and authorization patterns
   - Compliance with security best practices

3. **Functionality Review**
   - Logic correctness and completeness
   - Edge case handling
   - Error handling patterns
   - Resource lifecycle management

4. **Documentation Quality**
   - Example accuracy and completeness
   - Variable documentation clarity
   - Usage instructions
   - Migration guides for breaking changes

5. **Backward Compatibility**
   - Interface consistency
   - Deprecation handling
   - State migration implications
   - Version upgrade paths

### Best Practices for AI Validation

1. **Be Specific**: Request validation for specific aspects you're concerned about
2. **Use Multiple Agents**: Leverage different specialized agents for comprehensive coverage
3. **Request Examples**: Ask agents to provide concrete examples of issues found
4. **Iterative Review**: Request validation after addressing feedback
5. **Security First**: Always include security review for authentication/authorization changes

### Example Validation Workflow

```
# After implementing a new feature
@claude I've added support for custom email sender configuration. Please:
1. Use terraform-cognito agent to review the implementation
2. Use terraform-security agent to check for security issues
3. Use module-documentation agent to validate the examples
4. Provide specific feedback on any concerns or improvements needed

# After making security changes
@claude I've updated the account takeover prevention settings. Use the
terraform-security agent to perform a thorough security analysis and
verify this follows AWS security best practices.

# Before releasing changes
@claude Please use the cognito-migration and module-documentation agents
to verify backward compatibility and ensure documentation is complete
for the changes in this branch.
```

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
- Request AI validation for affected functionality using specialized agents
- Consider requesting security analysis using terraform-security agent
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
2. **AI Validation** - Request validation from specialized agents for new features and modifications
3. **Flexible Inputs** - Support multiple input formats where reasonable
4. **Validation Balance** - Add validation where it prevents common errors
5. **Consistent Naming** - Follow established naming conventions
6. **Resource Management** - Handle resource creation conflicts gracefully
7. **Backward Compatibility** - Maintain compatibility when possible
8. **Security Defaults** - Use secure defaults where appropriate

## Design Decisions

### Schema Change Visibility (main.tf dual resources)
**Decision**: Maintain dual `aws_cognito_user_pool` resources despite ~252 lines of code duplication.

**Rationale**: Schema change visibility in terraform plans is essential for:
- Change review workflows and team collaboration
- Compliance/audit requirements for new user attributes
- Application coordination when schema attributes are added
- Debugging and validation of configuration changes

**Trade-off**: Code duplication is acceptable to preserve user choice between:
- `ignore_schema_changes = false` → See schema additions in plans (change management)
- `ignore_schema_changes = true` → Hide schema changes (simplicity)

**Reference**: PR #271 analysis (Aug 2025) - consolidation attempt rejected to preserve workflow visibility.

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

## MCP Server Configuration

### Available MCP Servers
This project is configured to use the following Model Context Protocol (MCP) servers for enhanced documentation access:

#### Terraform MCP Server
**Purpose**: Access up-to-date Terraform and AWS provider documentation
**Package**: `@modelcontextprotocol/server-terraform`

**Local Configuration** (`.mcp.json`):
```json
{
  "mcpServers": {
    "terraform": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-terraform@latest"]
    }
  }
}
```

**Usage Examples**:
- `Look up aws_cognito_user_pool resource documentation`
- `Find the latest Cognito User Pool client configuration examples`
- `Search for AWS Cognito Terraform modules`
- `Get documentation for aws_cognito_identity_provider resource`

#### Context7 MCP Server
**Purpose**: Access general library and framework documentation
**Package**: `@upstash/context7-mcp`

**Local Configuration** (`.mcp.json`):
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp@latest"]
    }
  }
}
```

**Usage Examples**:
- `Look up AWS Cognito security best practices`
- `Find AWS CLI cognito commands documentation`
- `Get current Terraform best practices`
- `Search for Terraform module development patterns`

### GitHub Actions Integration
The MCP servers are automatically available in GitHub Actions through the claude.yml workflow configuration. Claude can access the same documentation in PRs and issues as available locally.

### Usage Tips
1. **Be Specific**: When requesting documentation, specify the exact resource or concept
2. **Version Awareness**: Both servers provide current, version-specific documentation
3. **Combine Sources**: Use Terraform MCP for Cognito-specific docs, Context7 for general development patterns
4. **Local vs CI**: Same MCP servers work in both local development and GitHub Actions

### Example Workflows

**Cognito Resource Development**:
```
@claude I need to add support for Cognito advanced security features. Can you look up the latest aws_cognito_user_pool advanced_security_mode documentation and show me how to implement this feature?
```

**AI Validation Request**:
```
@claude Use the terraform-cognito and terraform-security agents to validate my implementation of user pool clients with identity providers. Check for security issues and AWS best practices.
```

**Security Enhancement**:
```
@claude Research the latest AWS Cognito security best practices and help me implement enhanced MFA configurations in this module.
```
