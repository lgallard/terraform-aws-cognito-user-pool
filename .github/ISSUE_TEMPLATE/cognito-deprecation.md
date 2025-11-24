---
name: ⚠️ Cognito User Pool Feature Deprecation
about: Auto-discovered deprecated AWS Cognito User Pool feature requiring action
title: "chore: Handle deprecation of [DEPRECATED_FEATURE]"
labels: ["deprecation", "breaking-change", "aws-provider-update", "auto-discovered"]
assignees: []
---

## ⚠️ Cognito User Pool Feature Deprecation Notice

**AWS Provider Version:** v[PROVIDER_VERSION]
**Deprecated Feature:** `[DEPRECATED_FEATURE]`
**Deprecation Date:** `[DEPRECATION_DATE]`
**Planned Removal:** `[REMOVAL_VERSION]` (if known)
**Priority:** P1-High
**Auto-detected:** ✅ `[SCAN_DATE]`

### Deprecation Details
<!-- Auto-extracted from AWS provider documentation -->
[DEPRECATION_DESCRIPTION]

### Current Usage in Module
**Files Affected:**
- [ ] `main.tf` - [USAGE_DETAILS]
- [ ] `client.tf` - [USAGE_DETAILS]
- [ ] `domain.tf` - [USAGE_DETAILS]
- [ ] `identity-provider.tf` - [USAGE_DETAILS]
- [ ] `resource-server.tf` - [USAGE_DETAILS]
- [ ] `user-group.tf` - [USAGE_DETAILS]
- [ ] `variables.tf` - [VARIABLE_REFERENCES]
- [ ] `outputs.tf` - [OUTPUT_REFERENCES]
- [ ] `examples/*/` - [EXAMPLE_USAGE]

**Impact Assessment:**
- **Severity:** [High/Medium/Low]
- **User Impact:** [Breaking/Non-breaking]
- **Module Components Affected:** [List of components]

### Migration Path
<!-- Auto-extracted migration guidance from provider docs -->

#### Recommended Replacement
```hcl
# OLD (Deprecated)
[OLD_CONFIGURATION]

# NEW (Recommended)
[NEW_CONFIGURATION]
```

### Action Plan

#### Phase 1: Assessment & Planning
- [ ] **Audit Current Usage**
  - [ ] Search all module files for deprecated feature usage
  - [ ] Identify all examples using the deprecated feature
  - [ ] Document impact on existing users
- [ ] **Validate Migration**
  - [ ] Create validation branch with new implementation
  - [ ] Validate functionality with new approach
  - [ ] Ensure backward compatibility during transition

#### Phase 2: Implementation
- [ ] **Update Module Code**
  - [ ] Replace deprecated feature with recommended alternative
  - [ ] Add conditional logic for smooth transition (if possible)
  - [ ] Update variable descriptions and validation
  - [ ] Add deprecation warnings in variable descriptions
- [ ] **Update Examples**
  - [ ] Modify all affected examples
  - [ ] Add migration examples showing both old and new patterns
  - [ ] Update example documentation

#### Phase 3: Documentation & Communication
- [ ] **Update Documentation**
  - [ ] Add deprecation notice to README
  - [ ] Document migration steps for users
  - [ ] Update variable documentation
  - [ ] Add to CHANGELOG.md with migration guidance
- [ ] **Add Deprecation Warnings**
  - [ ] Add validation warnings for deprecated usage
  - [ ] Include migration instructions in validation messages
  - [ ] Plan timeline for complete removal

#### Phase 4: AI Validation & Quality Assurance
- [ ] **Comprehensive Validation**
  - [ ] Validate all examples with new implementation
  - [ ] Request AI validation with specialized agents
  - [ ] Validate backward compatibility
  - [ ] Validate upgrade scenarios
- [ ] **Quality Assurance**
  - [ ] Run `terraform fmt`, `terraform validate`
  - [ ] Run `pre-commit run --all-files`
  - [ ] Peer review migration approach

### Timeline
- **Deprecation Notice:** `[DEPRECATION_DATE]`
- **Migration Deadline:** `[MIGRATION_DEADLINE]`
- **Planned Removal:** `[REMOVAL_DATE]`
- **Our Target Migration:** `[OUR_TIMELINE]`

### Provider Documentation
- **Deprecation Notice:** [DEPRECATION_DOCS_LINK]
- **Migration Guide:** [MIGRATION_GUIDE_LINK]
- **New Feature Docs:** [NEW_FEATURE_DOCS_LINK]

### User Communication Strategy
```markdown
# Deprecation Notice Template for README

⚠️ **Deprecation Warning**: The `[DEPRECATED_FEATURE]` feature is deprecated as of AWS Provider v[VERSION].

**What's changing:** [BRIEF_DESCRIPTION]
**Timeline:** Deprecated in v[VERSION], will be removed in v[FUTURE_VERSION]
**Action required:** [MIGRATION_STEPS]

**Migration example:**
```hcl
# Before (deprecated)
[OLD_CONFIG]

# After (recommended)
[NEW_CONFIG]
```

For detailed migration instructions, see [MIGRATION_GUIDE_LINK].
```

### Cognito-Specific Impact Assessment
- [ ] **User Pool Configuration**
  - [ ] Impact on user pool creation and management
  - [ ] Changes to authentication settings
  - [ ] Effect on user pool policies
- [ ] **Client Applications**
  - [ ] Impact on user pool clients
  - [ ] Changes to authentication flows
  - [ ] Effect on client configurations
- [ ] **Identity Federation**
  - [ ] Impact on identity providers
  - [ ] Changes to federated authentication
  - [ ] Effect on SAML/OIDC configurations
- [ ] **User Experience**
  - [ ] Impact on login/signup flows
  - [ ] Changes to UI customization
  - [ ] Effect on branding configurations

### Breaking Change Considerations
- [ ] **Semantic Versioning Impact**
  - [ ] Determine if this requires major version bump
  - [ ] Plan release strategy (immediate patch vs next major)
  - [ ] Consider feature flag approach for transition period
- [ ] **User Migration Support**
  - [ ] Provide clear migration examples
  - [ ] Consider supporting both approaches temporarily
  - [ ] Add helpful validation messages

### Example Migration
```hcl
# Example showing before/after for module users

# BEFORE (using deprecated feature)
module "cognito_old" {
  source = "./terraform-aws-cognito-user-pool"

  user_pool_name = "my-app"
  [DEPRECATED_USAGE]
}

# AFTER (using new approach)
module "cognito_new" {
  source = "./terraform-aws-cognito-user-pool"

  user_pool_name = "my-app"
  [NEW_APPROACH]
}
```

### Validation Commands
```bash
# Validate with deprecated feature (should show warnings)
terraform plan

# Validate migration path
terraform init -upgrade
terraform validate
terraform plan

# Request AI validation
# @claude Use cognito-migration and terraform-security agents to validate
# the deprecation migration. Ensure backward compatibility and proper
# migration path for users.
```

### Acceptance Criteria
- [ ] All deprecated usage removed from module
- [ ] Migration path documented and validated
- [ ] Backward compatibility maintained (if possible)
- [ ] Users have clear migration instructions
- [ ] AI validation completed with specialized agents
- [ ] Documentation updated with migration guidance
- [ ] Deprecation warnings implemented (if gradual migration)

---

### 🤖 Automation Details
**Discovery Workflow:** `feature-discovery.yml`
**Scan ID:** `[SCAN_ID]`
**Detection Method:** AWS Provider deprecation analysis
**Last Updated:** `[TIMESTAMP]`

---

*This issue was automatically created by the Cognito User Pool Feature Discovery workflow. Please review the auto-generated content and prioritize based on removal timeline.*
