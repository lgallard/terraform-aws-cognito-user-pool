# The simple example

This example creates a basic AWS Cognito User Pool with minimal configuration and follows best practices for new deployments.

## Best Practices

💡 **Recommendation**: Even for simple configurations, it's recommended to set `ignore_schema_changes = true` to prevent issues if you decide to add custom schemas in the future.

```hcl
module "aws_cognito_user_pool_simple_example" {

  source = "lgallard/cognito-user-pool/aws"

  user_pool_name = "simple_pool"

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas in the future
  ignore_schema_changes = true

  # tags
  tags = {
    Owner       = "infra"
    Environment = "production"
    Terraform   = true
  }
}
```
