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
  value       = var.domain_name
}

output "hosted_ui_url" {
  description = "The hosted UI URL"
  value       = var.domain_name != "" ? "https://${var.domain_name}.auth.${var.aws_region}.amazoncognito.com/login" : null
}

output "managed_login_branding_details" {
  description = "The managed login branding details from the module"
  value       = module.aws_cognito_user_pool.managed_login_branding_details
}

output "client_ids_map" {
  description = "Map of user pool client IDs"
  value       = module.aws_cognito_user_pool.client_ids_map
}
