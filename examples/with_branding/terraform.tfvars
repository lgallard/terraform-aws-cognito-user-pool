# Example configuration for Cognito User Pool with Managed Login Branding

user_pool_name = "my-app-user-pool-with-branding"
user_pool_tier = "ESSENTIALS"

# Optional: Set a custom domain for hosted UI
# domain_name = "my-app-auth"

aws_region = "us-east-1"

tags = {
  Environment = "development"
  Project     = "my-app"
  Owner       = "platform-team"
}