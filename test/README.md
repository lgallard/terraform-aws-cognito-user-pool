# Terraform AWS Cognito User Pool - Testing Framework

This directory contains a comprehensive testing framework for the terraform-aws-cognito-user-pool module using [Terratest](https://terratest.gruntwork.io/).

## Overview

The testing framework includes:

- **Unit Tests**: Variable validation and resource configuration logic
- **Integration Tests**: Real AWS resource creation and validation
- **Security Tests**: MFA, password policies, and security configurations
- **Example Tests**: All example configurations in the `/examples` directory
- **Automated CI/CD**: GitHub Actions workflow for continuous testing

## Directory Structure

```
test/
├── README.md                    # This file
├── go.mod                      # Go module dependencies
├── go.sum                      # Go module checksums (auto-generated)
├── unit/                       # Unit tests
│   ├── variable_validation_test.go
│   └── resource_logic_test.go
├── integration/                # Integration tests
│   ├── examples_test.go
│   ├── core_functionality_test.go
│   └── security_test.go
├── fixtures/                   # Test fixtures and configurations
│   └── complete-config/        # Complete test configuration
├── helpers/                    # Test helper functions
│   ├── aws.go                  # AWS-specific helpers
│   └── terraform.go            # Terraform-specific helpers
```

## Prerequisites

### Required Tools

- [Go](https://golang.org/) 1.21 or later
- [Terraform](https://www.terraform.io/) 1.6.0 or later
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials

### AWS Credentials

For integration tests, you need AWS credentials configured:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

Or use AWS CLI configuration:
```bash
aws configure
```

### IAM Permissions

The test user/role needs the following IAM permissions:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cognito-idp:*",
                "iam:CreateRole",
                "iam:DeleteRole",
                "iam:AttachRolePolicy",
                "iam:DetachRolePolicy",
                "iam:PutRolePolicy",
                "iam:DeleteRolePolicy",
                "iam:GetRole",
                "iam:PassRole"
            ],
            "Resource": "*"
        }
    ]
}
```

## Running Tests

### Setup

First, initialize the Go module:

```bash
cd test
go mod download
```

### Unit Tests

Unit tests validate Terraform configurations without creating AWS resources:

```bash
# Run all unit tests
go test -v ./unit/

# Run specific test
go test -v -run TestUserPoolTierValidation ./unit/

# Run unit tests with timeout
go test -v -timeout 10m ./unit/
```

### Integration Tests

Integration tests create real AWS resources. **These tests incur AWS charges.**

```bash
# Run all integration tests (takes 20-30 minutes)
go test -v -timeout 45m ./integration/

# Run specific example test
go test -v -timeout 15m -run TestSimpleExample ./integration/

# Run core functionality tests
go test -v -timeout 15m -run TestBasicUserPoolCreation ./integration/

# Run security tests
go test -v -timeout 15m -run TestMFASecurityConfigurations ./integration/
```

### Parallel Execution

Tests are designed to run in parallel for faster execution:

```bash
# Run tests in parallel (default behavior)
go test -v -parallel 4 ./integration/

# Run specific tests in parallel
go test -v -parallel 2 -run "TestSimple|TestComplete" ./integration/
```

### Example-Specific Tests

Test individual examples:

```bash
# Test simple example
go test -v -run TestSimpleExample ./integration/

# Test complete example
go test -v -run TestCompleteExample ./integration/

# Test email MFA example
go test -v -run TestEmailMFAExample ./integration/

# Test simple extended example
go test -v -run TestSimpleExtendedExample ./integration/

# Test with branding example
go test -v -run TestWithBrandingExample ./integration/
```

## Test Categories

### 1. Unit Tests (`unit/`)

#### Variable Validation Tests
- **Purpose**: Validate input variable constraints and types
- **Location**: `unit/variable_validation_test.go`
- **Tests**:
  - `TestUserPoolTierValidation`: Validates user_pool_tier values
  - `TestRequiredVariables`: Validates required vs optional variables
  - `TestPasswordPolicyValidation`: Validates password policy constraints
  - `TestEnabledFlagValidation`: Validates enabled flag type checking

#### Resource Logic Tests
- **Purpose**: Test resource creation logic without AWS API calls
- **Location**: `unit/resource_logic_test.go`
- **Tests**:
  - `TestConditionalResourceCreation`: Tests enabled/disabled resource creation
  - `TestClientConfiguration`: Tests client configuration logic
  - `TestDomainConfiguration`: Tests domain configuration logic
  - `TestMFAConfiguration`: Tests MFA configuration validation

### 2. Integration Tests (`integration/`)

#### Example Tests
- **Purpose**: Test all example configurations end-to-end
- **Location**: `integration/examples_test.go`
- **Tests**:
  - `TestSimpleExample`: Basic user pool creation
  - `TestCompleteExample`: Complete configuration with all features
  - `TestEmailMFAExample`: Email-based MFA configuration
  - `TestSimpleExtendedExample`: Extended simple configuration
  - `TestWithBrandingExample`: User pool with custom branding
  - `TestAllExamplesResourceDestruction`: Validates proper resource cleanup

#### Core Functionality Tests
- **Purpose**: Test core module functionality
- **Location**: `integration/core_functionality_test.go`
- **Tests**:
  - `TestBasicUserPoolCreation`: Basic user pool creation
  - `TestUserPoolWithClients`: User pool with multiple clients
  - `TestUserPoolWithDomain`: User pool with custom domain
  - `TestUserPoolWithPasswordPolicy`: Password policy configuration
  - `TestUserPoolWithMFA`: MFA configuration
  - `TestUserPoolWithUserGroups`: User groups configuration
  - `TestUserPoolDisabled`: Disabled user pool (no resources created)

#### Security Tests
- **Purpose**: Test security-related configurations
- **Location**: `integration/security_test.go`
- **Tests**:
  - `TestMFASecurityConfigurations`: Various MFA configurations
  - `TestPasswordPolicySecurityRequirements`: Password policy enforcement
  - `TestAccountTakeoverPrevention`: Account recovery mechanisms
  - `TestUserPoolSecurityAttributes`: Security attributes validation
  - `TestClientSecuritySettings`: Client security configurations
  - `TestAdvancedSecurityFeatures`: Advanced security mode and device configuration

### 3. Test Helpers (`helpers/`)

#### AWS Helpers (`helpers/aws.go`)
- `GenerateUniqueUserPoolName()`: Generate unique names for testing
- `GetCognitoClient()`: Create AWS Cognito client
- `ValidateUserPoolExists()`: Validate user pool creation
- `ValidateUserPoolClient()`: Validate user pool client creation
- `ValidateUserPoolDomain()`: Validate domain creation
- `ValidateUserPoolDestroyed()`: Validate resource cleanup
- `GetDefaultTags()`: Get standard test tags

#### Terraform Helpers (`helpers/terraform.go`)
- `GetTerraformOptions()`: Create standard Terraform options
- `GetDefaultVars()`: Get default test variables
- `ApplyAndValidate()`: Apply Terraform and run validation
- `PlanAndValidate()`: Plan Terraform and validate resource count
- Path helpers for modules, examples, and fixtures

## CI/CD Integration

### GitHub Actions Workflow

The testing framework integrates with GitHub Actions (`.github/workflows/test.yml`):

#### Workflow Jobs

1. **Unit Tests** (`unit-tests`)
   - Runs on every push and PR
   - Tests variable validation and resource logic
   - Timeout: 10 minutes
   - No AWS credentials required

2. **Integration Tests** (`integration-tests`)
   - Runs on push to master or PRs with `integration-test` label
   - Tests real AWS resource creation
   - Timeout: 45 minutes
   - Requires AWS credentials

3. **Example Validation** (`example-validation`)
   - Validates all example configurations
   - Runs `terraform fmt`, `init`, `validate`, and `plan`
   - No AWS credentials required

4. **Destruction Tests** (`destruction-tests`)
   - Tests proper resource cleanup
   - Runs on push to master or PRs with `destruction-test` label
   - Requires AWS credentials

5. **Test Summary** (`test-summary`)
   - Aggregates results from all test jobs
   - Provides summary in GitHub Actions output

#### Triggering Integration Tests

Integration tests run automatically on:
- Push to `master` branch
- Pull requests with the `integration-test` label

To trigger integration tests on a PR:
```bash
# Add label to PR
gh pr edit <PR_NUMBER> --add-label "integration-test"
```

#### Workflow Configuration

Key configuration:
- **Terraform Version**: 1.6.0
- **Go Version**: 1.21
- **AWS Region**: us-east-1
- **Test Timeout**: Variable per job (10-45 minutes)
- **Parallel Execution**: Tests run in parallel where possible

## Best Practices

### Test Development

1. **Parallel Execution**: Use `t.Parallel()` in all tests
2. **Unique Names**: Always generate unique resource names
3. **Resource Cleanup**: Always defer `terraform.Destroy()`
4. **Timeouts**: Set appropriate timeouts for integration tests
5. **Error Handling**: Use `assert` and `require` appropriately

### Test Organization

1. **Logical Grouping**: Group related tests in the same file
2. **Clear Naming**: Use descriptive test function names
3. **Documentation**: Comment complex test scenarios
4. **Fixtures**: Use fixtures for complex configurations

### AWS Best Practices

1. **Cost Optimization**: Clean up resources immediately after testing
2. **Region Selection**: Use consistent AWS regions (default: us-east-1)
3. **IAM Permissions**: Use minimal required permissions
4. **Resource Tagging**: Tag all test resources for identification

## Troubleshooting

### Common Issues

#### Go Module Issues
```bash
# Clear module cache
go clean -modcache
cd test && go mod download
```

#### AWS Credential Issues
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Check configured region
aws configure get region
```

#### Terraform State Issues
```bash
# Clean up any stuck Terraform state
cd test && find . -name "terraform.tfstate*" -delete
cd test && find . -name ".terraform" -type d -exec rm -rf {} +
```

#### Resource Cleanup Issues
```bash
# Manual cleanup of test resources
aws cognito-idp list-user-pools --max-items 60 --query 'UserPools[?starts_with(Name, `test-`)].{Name:Name,Id:Id}'
```

### Test Timeouts

If tests timeout, consider:
1. Increasing timeout values in test commands
2. Running fewer tests in parallel
3. Using more powerful CI/CD runners
4. Splitting large test suites

### Debug Mode

Enable verbose output for debugging:
```bash
# Run with verbose output
go test -v -run TestSpecificTest ./integration/

# Run with race detection
go test -race -v ./unit/

# Run with coverage
go test -cover -v ./unit/
```

## Performance Considerations

### Test Execution Time

- **Unit Tests**: ~2-5 minutes
- **Integration Tests**: ~20-30 minutes
- **All Tests**: ~35-45 minutes

### Cost Optimization

Integration tests create real AWS resources and incur costs:
- User pools are typically free tier eligible
- Domain registration may incur charges
- Clean up is automatic but verify completion

### Parallel Execution

Tests are designed for parallel execution:
- Unit tests: Safe for high parallelism (4-8 parallel)
- Integration tests: Limited parallelism due to AWS rate limits (2-4 parallel)

## Contributing

### Adding New Tests

1. **Unit Tests**: Add to appropriate file in `unit/`
2. **Integration Tests**: Add to appropriate file in `integration/`
3. **Helper Functions**: Add to `helpers/` if reusable
4. **Test Fixtures**: Add to `fixtures/` for complex scenarios

### Test Naming Conventions

- Use descriptive names: `TestUserPoolWithAdvancedSecurity`
- Group related tests: `TestMFA*`, `TestPassword*`
- Include expected behavior: `TestInvalidConfigurationFails`

### Documentation Updates

When adding tests:
1. Update this README with new test descriptions
2. Add inline comments for complex test logic
3. Update CI/CD workflow if needed
4. Update IAM permissions if new AWS services are used

## Maintenance

### Regular Tasks

1. **Dependency Updates**: Update Go modules and Terraform providers
2. **CI/CD Updates**: Keep GitHub Actions up to date
3. **Cost Monitoring**: Monitor AWS costs from test executions
4. **Performance Review**: Optimize slow tests

### Version Compatibility

- **Terraform**: Keep compatible with minimum version in `versions.tf`
- **AWS Provider**: Test with latest and minimum supported versions
- **Go**: Use stable Go version (currently 1.21)
- **Terratest**: Keep updated for latest features and bug fixes# Integration test trigger
