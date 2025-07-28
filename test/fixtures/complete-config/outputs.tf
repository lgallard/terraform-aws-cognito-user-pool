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

output "domain" {
  description = "Holds the domain prefix if the user pool has a domain associated with it"
  value       = module.cognito_user_pool_test.domain
}

output "clients" {
  description = "User pool clients"
  value       = module.cognito_user_pool_test.clients
}

output "user_groups" {
  description = "User groups"
  value       = module.cognito_user_pool_test.user_groups
}

output "managed_login_branding" {
  description = "Managed login branding"
  value       = module.cognito_user_pool_test.managed_login_branding
}

output "ui_customization" {
  description = "UI customization"
  value       = module.cognito_user_pool_test.ui_customization
}
