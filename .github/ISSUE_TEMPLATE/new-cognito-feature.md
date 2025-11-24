---
name: 🚀 New Cognito User Pool Feature
about: Auto-discovered new AWS Cognito User Pool feature for implementation
title: "feat: Add support for [FEATURE_NAME]"
labels: ["enhancement", "aws-provider-update", "auto-discovered"]
assignees: []
---

## 🚀 New Cognito User Pool Feature Discovery

**AWS Provider Version:** v[PROVIDER_VERSION]
**Feature Type:** [Resource/Argument/Data Source]
**Priority:** [P0-Critical/P1-High/P2-Medium/P3-Low]
**Auto-detected:** ✅ `[SCAN_DATE]`

### Description
<!-- Auto-extracted from AWS provider documentation -->
[FEATURE_DESCRIPTION]

### Provider Documentation
- **Provider Docs:** [PROVIDER_DOCS_LINK]
- **AWS Service Docs:** [AWS_DOCS_LINK]
- **Terraform Registry:** [REGISTRY_LINK]

### Implementation Requirements

#### Code Changes
- [ ] Add to `main.tf` or relevant module file
- [ ] Add input variables to `variables.tf`
- [ ] Add outputs to `outputs.tf` (if applicable)
- [ ] Update locals files (if needed)
- [ ] Handle conditional resource creation
- [ ] Update client configurations in `client.tf` (if applicable)
- [ ] Update domain configurations in `domain.tf` (if applicable)
- [ ] Update identity provider configurations in `identity-provider.tf` (if applicable)

#### Examples & Documentation
- [ ] Create example in `examples/[feature-name]/`
- [ ] Add to `examples/complete/` comprehensive example
- [ ] Update main `README.md`
- [ ] Add to `CHANGELOG.md` (will be automated by release-please)

#### AI Validation & Quality Checks
- [ ] Request validation from `terraform-cognito` agent for implementation review
- [ ] Request validation from `terraform-security` agent for security analysis
- [ ] Request validation from `module-documentation` agent for examples
- [ ] Validate with `examples/complete` scenario
- [ ] Run `terraform fmt`, `terraform validate`
- [ ] Run `pre-commit run --all-files`

#### Quality Assurance
- [ ] Follow existing code patterns and conventions
- [ ] Add proper variable validation rules
- [ ] Include appropriate default values
- [ ] Add comprehensive variable descriptions
- [ ] Ensure backward compatibility

### Example Configuration
```hcl
# Auto-generated example from provider documentation
module "cognito_user_pool" {
  source = "./terraform-aws-cognito-user-pool"

  user_pool_name = "my-user-pool"

  # New feature implementation
  [FEATURE_EXAMPLE]

  tags = {
    Environment = "production"
    Feature     = "[FEATURE_NAME]"
  }
}
```

### Expected Outputs
```hcl
# If this feature provides new outputs
output "[feature_output]" {
  description = "[Output description]"
  value       = [output_reference]
}
```

### Validation Commands
```bash
# Validate the specific example
cd examples/[feature-name]
terraform init
terraform validate
terraform plan

# Request AI validation
# Use specialized agents for comprehensive validation:
# @claude Use terraform-cognito and terraform-security agents to validate
# the [feature-name] implementation. Check for AWS best practices,
# security concerns, and proper integration with existing module patterns.
```

### Implementation Notes
<!-- Additional context or considerations -->
- [ ] **Backward Compatibility**: Ensure changes don't break existing configurations
- [ ] **Default Values**: Use sensible defaults that maintain current behavior
- [ ] **Validation**: Add appropriate variable validation where needed
- [ ] **Dependencies**: Check for new required provider features or versions
- [ ] **Authentication Flows**: Consider impact on existing auth flows
- [ ] **Security**: Evaluate security implications and best practices

### Cognito-Specific Considerations
- [ ] **User Pool Impact**: How does this affect user pool configuration?
- [ ] **Client Impact**: Does this require changes to user pool clients?
- [ ] **Authentication**: Impact on authentication and authorization flows
- [ ] **MFA Integration**: Compatibility with MFA configurations
- [ ] **Identity Providers**: Integration with federated identity providers
- [ ] **User Experience**: Impact on login/signup user experience
- [ ] **Security Features**: New security capabilities or requirements

### Acceptance Criteria
- [ ] Feature implemented following module patterns
- [ ] AI validation completed with specialized agents
- [ ] Examples work as documented
- [ ] Pre-commit hooks pass
- [ ] Documentation complete and accurate
- [ ] No breaking changes to existing functionality
- [ ] Feature works with all existing examples
- [ ] Cognito-specific patterns maintained

### Provider Compatibility
**Minimum AWS Provider Version:** `>= [MIN_VERSION]`
**Terraform Version:** `>= 1.0` (current module requirement)

---

### 🤖 Automation Details
**Discovery Workflow:** `feature-discovery.yml`
**Scan ID:** `[SCAN_ID]`
**Detection Method:** Terraform MCP Server analysis
**Last Updated:** `[TIMESTAMP]`

---

*This issue was automatically created by the Cognito User Pool Feature Discovery workflow. Please review the auto-generated content and update as needed before implementation.*
