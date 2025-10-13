# Refresh Token Rotation Example

This example demonstrates how to configure AWS Cognito User Pool with refresh token rotation enabled for enhanced security.

## Features Demonstrated

- **Refresh Token Rotation**: Enables automatic rotation of refresh tokens for enhanced security
- **Configurable Grace Period**: Sets a retry grace period for token rotation failures
- **Token Validity Configuration**: Demonstrates proper token lifetime settings
- **Security Best Practices**: Combines refresh token rotation with token revocation

## Refresh Token Rotation Benefits

Refresh token rotation is a security best practice that provides:

1. **Enhanced Security**: Each token refresh provides a completely new set of tokens
2. **Reduced Token Exposure**: Limits the window of vulnerability for compromised tokens
3. **Replay Attack Protection**: Old refresh tokens become invalid after use
4. **Configurable Grace Period**: Allows handling of network issues and retries

## Configuration Details

### Refresh Token Rotation

```hcl
refresh_token_rotation = {
  type                       = "rotate"        # Enable rotation
  retry_grace_period_seconds = 300            # 5 minute grace period
}
```

- **type**: Set to "rotate" to enable refresh token rotation, or "disabled" to disable
- **retry_grace_period_seconds**: Grace period (0-86400 seconds) for handling retry scenarios

### Token Validity Settings

The example demonstrates recommended token validity periods:

- **Access tokens**: 60 minutes (short-lived for security)
- **ID tokens**: 60 minutes (short-lived for security)  
- **Refresh tokens**: 30 days (longer-lived but with rotation)

## Usage

1. Clone this repository
2. Navigate to this example directory
3. Configure your AWS credentials
4. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

## Security Considerations

When implementing refresh token rotation:

1. **Client Implementation**: Ensure your application can handle new token sets on each refresh
2. **Error Handling**: Implement proper error handling for token rotation failures
3. **Grace Period**: Set appropriate grace period based on your network conditions
4. **Token Storage**: Store tokens securely and update all stored tokens on rotation

## Clean Up

To clean up the resources created by this example:

```bash
terraform destroy
```

## More Information

- [AWS Cognito Refresh Token Rotation Documentation](https://docs.aws.amazon.com/cognito/latest/developerguide/amazon-cognito-user-pools-using-the-refresh-token.html)
- [Terraform AWS Cognito User Pool Client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client)