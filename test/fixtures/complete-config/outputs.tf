output "id" {
  description = "The id of the user pool"
  value       = module.cognito_user_pool_test.id
}

output "arn" {
  description = "The ARN of the user pool"
  value       = module.cognito_user_pool_test.arn
}

output "name" {
  description = "The name of the user pool"
  value       = module.cognito_user_pool_test.name
}

output "creation_date" {
  description = "The date the user pool was created"
  value       = module.cognito_user_pool_test.creation_date
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = module.cognito_user_pool_test.last_modified_date
}

output "endpoint" {
  description = "The endpoint name of the user pool"
  value       = module.cognito_user_pool_test.endpoint
}

output "domain_aws_account_id" {
  description = "Domain AWS account ID"
  value       = module.cognito_user_pool_test.domain_aws_account_id
}

output "client_ids" {
  description = "User pool client IDs"
  value       = module.cognito_user_pool_test.client_ids
}

output "user_group_ids" {
  description = "User group IDs"
  value       = module.cognito_user_pool_test.user_group_ids
}

output "managed_login_branding" {
  description = "Managed login branding"
  value       = module.cognito_user_pool_test.managed_login_branding
}

output "managed_login_branding_details" {
  description = "Managed login branding details"
  value       = module.cognito_user_pool_test.managed_login_branding_details
}
