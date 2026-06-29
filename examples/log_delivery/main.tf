# Cognito log delivery has destination prerequisites outside this module.
# For CloudWatch Logs, the caller must have logs delivery permissions such as
# logs:CreateLogDelivery, logs:PutResourcePolicy, logs:DescribeResourcePolicies,
# and logs:DescribeLogGroups. See the README log delivery section and the AWS
# Cognito log export documentation for the full destination-policy prerequisites.
# The log group must be in the same AWS account as the user pool and must not be
# encrypted with AWS KMS.
resource "aws_cloudwatch_log_group" "cognito_user_notification_errors" {
  name              = "/aws/vendedlogs/cognito/log-delivery-pool/user-notification-errors"
  retention_in_days = 30

  tags = {
    Owner       = "infra"
    Environment = "example"
    Terraform   = true
  }
}

module "aws_cognito_user_pool_log_delivery_example" {

  source = "../../"

  user_pool_name = "log_delivery_pool"

  # Recommended: Enable schema ignore changes for new deployments
  # This prevents perpetual diffs if you plan to use custom schemas in the future
  ignore_schema_changes = true

  log_delivery_configuration = {
    log_configurations = [
      {
        event_source = "userNotification"
        log_level    = "ERROR"

        cloud_watch_logs_configuration = {
          log_group_arn = aws_cloudwatch_log_group.cognito_user_notification_errors.arn
        }
      }
    ]
  }

  tags = {
    Owner       = "infra"
    Environment = "example"
    Terraform   = true
  }
}
