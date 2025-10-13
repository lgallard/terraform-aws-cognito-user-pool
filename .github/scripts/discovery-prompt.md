# Cognito User Pool Feature Discovery Prompts

This document contains standardized prompts for Claude Code to ensure consistent feature discovery analysis.

## Main Discovery Prompt

```
# Cognito User Pool Feature Discovery Analysis

You are performing automated feature discovery for the terraform-aws-cognito-user-pool module to identify new AWS Cognito User Pool features, deprecations, and bug fixes.

## Context
- Repository: terraform-aws-cognito-user-pool
- Current Provider Support: AWS Provider >= 4.0.0
- Module Structure: Main user pool + client + domain + identity providers + managed login branding
- Examples: 5 comprehensive examples covering different authentication scenarios

## Discovery Process

### Step 1: Load Current State
Read the feature tracking database to understand what's already implemented:
```bash
cat .github/feature-tracker/cognito-features.json
```

### Step 2: Fetch Latest Cognito Documentation

Use the Terraform MCP server to get comprehensive Cognito documentation:

**Cognito Resources:**
```
mcp__terraform-server__resolveProviderDocID:
- providerName: "aws"
- providerNamespace: "hashicorp"
- serviceSlug: "cognito"
- providerVersion: "latest"
- providerDataType: "resources"
```

**Cognito Data Sources:**
```
mcp__terraform-server__resolveProviderDocID:
- providerName: "aws"
- providerNamespace: "hashicorp"
- serviceSlug: "cognito"
- providerVersion: "latest"
- providerDataType: "data-sources"
```

### Step 3: Analyze Current Implementation

Examine module structure and extract implementation details:

**Core Files to Analyze:**
- `main.tf` - Primary Cognito User Pool resource and configuration
- `client.tf` - User pool client configurations
- `domain.tf` - User pool domain configurations
- `identity-provider.tf` - Identity provider configurations
- `resource-server.tf` - Resource server configurations
- `user-group.tf` - User group configurations
- `managed-login-branding.tf` - Managed login branding configurations
- `ui-customization.tf` - UI customization configurations
- `variables.tf` - All input variables and their usage
- `outputs.tf` - Module outputs

**Examples Directory:**
Check `examples/*/main.tf` files to understand supported patterns:
- simple, simple_extended, complete
- email_mfa, with_branding

### Step 4: Intelligent Comparison

Compare provider documentation against current implementation:

**New Features to Detect:**
1. **New Resources:** Any `aws_cognito_*` resources not in module
2. **New Arguments:** New arguments on existing resources
3. **New Data Sources:** New `data.aws_cognito_*` sources
4. **New Authentication Features:** Advanced authentication flows, adaptive authentication
5. **New Security Features:** Enhanced MFA, risk-based authentication, account takeover protection
6. **New User Management:** Advanced user pool features, user migration capabilities
7. **New Branding Features:** Enhanced UI customization, managed login capabilities
8. **New Federation Features:** Enhanced identity provider integration

**Deprecations to Find:**
1. **Deprecated Arguments:** Arguments marked for removal
2. **Deprecated Resources:** Resources being phased out
3. **Deprecated Authentication Flows:** Auth flows no longer recommended
4. **Deprecated Patterns:** Configuration patterns no longer recommended

**Bug Fixes to Identify:**
Use Context7 MCP server to check AWS provider changelogs:
```
mcp__context7__resolve-library-id: "terraform-provider-aws"
mcp__context7__get-library-docs: topic="cognito changes changelog"
```

### Step 5: Categorize and Prioritize

**Priority Classification:**
- **P0 (Critical):** Security vulnerabilities, authentication breaking changes
- **P1 (High):** New core authentication resources, major deprecations
- **P2 (Medium):** New arguments, authentication enhancements
- **P3 (Low):** Minor improvements, cosmetic changes

**Feature Categories:**
- **NEW_RESOURCE:** Entirely new Cognito resource type
- **NEW_ARGUMENT:** New argument on existing resource
- **NEW_DATA_SOURCE:** New data source for Cognito
- **ENHANCEMENT:** Improvement to existing functionality
- **DEPRECATION:** Feature being deprecated
- **BUG_FIX:** Important bug fix from provider
- **SECURITY:** Security-related update
- **AUTHENTICATION:** Authentication flow improvements

### Step 6: Issue Creation

For each significant finding, create GitHub issues using appropriate templates.

**Check for Duplicates First:**
```bash
gh issue list --label "auto-discovered" --state open
gh issue list --search "[FEATURE_NAME]" --state all
```

**Create Issues with Proper Data:**
```bash
# New Feature
gh issue create \
  --template .github/ISSUE_TEMPLATE/new-cognito-feature.md \
  --title "feat: Add support for [FEATURE_NAME]" \
  --label "enhancement,aws-provider-update,auto-discovered" \
  --body "[DETAILED_DESCRIPTION]"

# Deprecation
gh issue create \
  --template .github/ISSUE_TEMPLATE/cognito-deprecation.md \
  --title "chore: Handle deprecation of [DEPRECATED_FEATURE]" \
  --label "deprecation,breaking-change,auto-discovered" \
  --body "[DEPRECATION_DETAILS]"

# Bug Fix
gh issue create \
  --template .github/ISSUE_TEMPLATE/cognito-bug-fix.md \
  --title "fix: Address [BUG_DESCRIPTION]" \
  --label "bug,aws-provider-update,auto-discovered" \
  --body "[BUG_FIX_DETAILS]"
```

### Step 7: Update Tracking Database

Update `.github/feature-tracker/cognito-features.json`:

```json
{
  "metadata": {
    "last_scan": "[CURRENT_TIMESTAMP]",
    "provider_version": "[SCANNED_VERSION]",
    "scan_count": "[INCREMENTED_COUNT]"
  },
  "scan_history": [
    {
      "scan_date": "[CURRENT_TIMESTAMP]",
      "provider_version": "[SCANNED_VERSION]",
      "features_found": "[COUNT]",
      "deprecations_found": "[COUNT]",
      "fixes_found": "[COUNT]",
      "issues_created": "[ISSUE_NUMBERS]"
    }
  ],
  "discovered_features": {
    "new_resources": {
      "[RESOURCE_NAME]": {
        "discovered_date": "[DATE]",
        "provider_version": "[VERSION]",
        "issue_number": "[ISSUE_NUM]",
        "priority": "[P0/P1/P2/P3]",
        "status": "pending"
      }
    },
    // Similar structure for new_arguments, deprecations, etc.
  },
  "issues_created": [
    {
      "issue_number": "[NUM]",
      "feature_type": "[TYPE]",
      "feature_name": "[NAME]",
      "created_date": "[DATE]",
      "priority": "[PRIORITY]",
      "status": "open"
    }
  ]
}
```

## Quality Assurance Rules

**Avoid False Positives:**
1. Only flag features not already in module
2. Verify features are Cognito User Pool-specific (not general AWS)
3. Check if feature is already tracked as "pending"
4. Ensure feature is stable (not experimental)

**Issue Content Requirements:**
1. Include provider documentation links
2. Provide implementation examples
3. Add clear acceptance criteria
4. Estimate complexity/priority correctly
5. Include testing requirements

**Tracking Requirements:**
1. Update scan timestamp
2. Increment scan counter
3. Record all findings
4. Track issue numbers
5. Maintain history

## Cognito-Specific Focus Areas

**User Pool Management:**
- User pool configuration and settings
- User pool tiers and advanced features
- Account recovery and user migration

**Authentication & Authorization:**
- Authentication flows and grant types
- OAuth 2.0 and OIDC configurations
- Token validity and session management

**Security Features:**
- Multi-factor authentication (MFA)
- Advanced security features and risk-based authentication
- Account takeover protection

**User Management:**
- User attributes and schema customization
- User groups and role-based access
- User invitation and management workflows

**Federation & Identity Providers:**
- Social identity providers (Google, Facebook, Amazon, etc.)
- SAML and OIDC identity providers
- Attribute mapping and user data synchronization

**Branding & UI Customization:**
- Hosted UI customization
- Managed login branding
- Custom domains and SSL certificates

## Success Metrics

Track these metrics in your analysis:
- Features discovered vs actually new
- Issues created vs duplicates avoided
- Priority accuracy (validated later)
- Implementation time (tracked over time)

## Expected Output Format

Provide a structured summary:

```
## Cognito User Pool Feature Discovery Results

**Scan Details:**
- Timestamp: [TIMESTAMP]
- Provider Version: [VERSION]
- Scan Duration: [DURATION]

**Findings Summary:**
- New Features: [COUNT] ([P0]: [COUNT], [P1]: [COUNT], [P2]: [COUNT], [P3]: [COUNT])
- Deprecations: [COUNT]
- Bug Fixes: [COUNT]
- Total Issues Created: [COUNT]

**New Features Discovered:**
1. [FEATURE_NAME] (Priority: [P1], Issue: #[NUM])
   - Type: [Resource/Argument/Data Source]
   - Description: [BRIEF_DESC]
   - Implementation Complexity: [High/Medium/Low]

**Deprecations Found:**
1. [DEPRECATED_FEATURE] (Issue: #[NUM])
   - Removal Timeline: [TIMELINE]
   - Impact: [High/Medium/Low]
   - Migration Path: [AVAILABLE/NEEDS_RESEARCH]

**Bug Fixes Identified:**
1. [BUG_DESCRIPTION] (Issue: #[NUM])
   - Fixed in Version: [VERSION]
   - Module Impact: [DESCRIPTION]

**Actions Taken:**
- Updated feature tracking database
- Created [COUNT] GitHub issues
- No duplicates found
- All issues properly labeled and categorized

**Recommendations:**
- [RECOMMENDATION_1]
- [RECOMMENDATION_2]
```

## Error Handling

If any step fails:
1. Log the specific error
2. Continue with remaining steps
3. Report partial results
4. Suggest manual review for failed areas
```

Use this prompt structure consistently for all feature discovery runs to ensure comprehensive and accurate analysis.
