output "user_pool_id" {
  description = "The ID of the user pool"
  value       = module.aws_cognito_user_pool.id
}

output "user_pool_arn" {
  description = "The ARN of the user pool"
  value       = module.aws_cognito_user_pool.arn
}

output "user_pool_domain" {
  description = "The domain of the user pool"
  value       = var.domain_name != "" ? aws_cognito_user_pool_domain.main[0].domain : null
}

output "hosted_ui_url" {
  description = "The hosted UI URL"
  value       = var.domain_name != "" ? "https://${aws_cognito_user_pool_domain.main[0].domain}.auth.${var.aws_region}.amazoncognito.com/login" : null
}

output "managed_login_branding" {
  description = "The managed login branding configuration"
  value       = module.aws_cognito_user_pool.managed_login_branding
}

output "managed_login_branding_ids" {
  description = "The managed login branding IDs"
  value       = module.aws_cognito_user_pool.managed_login_branding_ids
}

output "clients" {
  description = "Map of user pool clients"
  value       = module.aws_cognito_user_pool.clients
}