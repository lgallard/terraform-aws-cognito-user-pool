output "id" {
  description = "The id of the user pool"
  value       = local.user_pool_id
}

output "arn" {
  description = "The ARN of the user pool"
  value       = var.enabled ? local.user_pool.arn : null
}

output "endpoint" {
  description = "The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = var.enabled ? local.user_pool.endpoint : null
}

output "creation_date" {
  description = "The date the user pool was created"
  value       = var.enabled ? local.user_pool.creation_date : null
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = var.enabled ? local.user_pool.last_modified_date : null
}

output "name" {
  description = "The name of the user pool"
  value       = var.enabled ? local.user_pool.name : null
}

#
# aws_cognito_user_pool_domain
#
output "domain_aws_account_id" {
  description = "The AWS account ID for the user pool owner"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.aws_account_id) : null
}

output "domain_cloudfront_distribution" {
  description = "The name of the CloudFront distribution"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.cloudfront_distribution) : null
}

output "domain_cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.cloudfront_distribution_arn) : null
}

output "domain_cloudfront_distribution_zone_id" {
  description = "The ZoneID of the CloudFront distribution"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.cloudfront_distribution_zone_id) : null
}

output "domain_s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.s3_bucket) : null
}

output "domain_app_version" {
  description = "The app version"
  value       = var.enabled ? join("", aws_cognito_user_pool_domain.domain.*.version) : null
}

#
# aws_cognito_user_pool_client
#
output "client_ids" {
  description = "The ids of the user pool clients"
  value       = var.enabled ? aws_cognito_user_pool_client.client.*.id : null
}

output "client_secrets" {
  description = " The client secrets of the user pool clients"
  value       = var.enabled ? aws_cognito_user_pool_client.client.*.client_secret : null
  sensitive   = true
}

output "client_ids_map" {
  description = "The ids map of the user pool clients"
  value       = var.enabled ? { for k, v in aws_cognito_user_pool_client.client : v.name => v.id } : null
}

output "client_secrets_map" {
  description = "The client secrets map of the user pool clients"
  value       = var.enabled ? { for k, v in aws_cognito_user_pool_client.client : v.name => v.client_secret } : null
  sensitive   = true
}

#
# aws_cognito_user_group
#
output "user_group_ids" {
  description = "The ids of the user groups"
  value       = var.enabled ? values(aws_cognito_user_group.main)[*].id : null
}

output "user_group_names" {
  description = "The names of the user groups"
  value       = var.enabled ? values(aws_cognito_user_group.main)[*].name : null
}

output "user_group_arns" {
  description = "The ARNs of the user groups"
  value = var.enabled ? [
    for group in values(aws_cognito_user_group.main) : "${local.user_pool.arn}/group/${group.name}"
  ] : null
}

output "user_groups_map" {
  description = "A map of user group names to their properties"
  value = var.enabled ? {
    for k, v in aws_cognito_user_group.main : k => {
      id          = v.id
      name        = v.name
      description = v.description
      precedence  = v.precedence
      role_arn    = v.role_arn
      arn         = "${local.user_pool.arn}/group/${v.name}"
    }
  } : null
}

#
# aws_cognito_resource_servers
#
output "resource_servers_scope_identifiers" {
  description = " A list of all scopes configured in the format identifier/scope_name"
  value       = var.enabled ? aws_cognito_resource_server.resource.*.scope_identifiers : null
}

#
# awscc_cognito_managed_login_branding
#
output "managed_login_branding_details" {
  description = "Complete managed login branding details"
  value = var.enabled && var.managed_login_branding_enabled ? {
    configurations = {
      for k, v in awscc_cognito_managed_login_branding.branding : k => {
        id                        = v.id
        managed_login_branding_id = v.managed_login_branding_id
        client_id                 = v.client_id
        user_pool_id              = v.user_pool_id
        assets                    = v.assets
        settings                  = v.settings
      }
    }
    ids = {
      for k, v in awscc_cognito_managed_login_branding.branding : k => v.managed_login_branding_id
    }
    } : {
    configurations = {}
    ids            = {}
  }
}

# Backward compatibility - keep existing outputs
output "managed_login_branding" {
  description = "Map of managed login branding configurations (deprecated - use managed_login_branding_details)"

  value       = local.managed_login_branding_map
}

output "managed_login_branding_ids" {
  description = "Map of managed login branding IDs (deprecated - use managed_login_branding_details.ids)"

  value = var.enabled && var.managed_login_branding_enabled ? {
    for k, v in awscc_cognito_managed_login_branding.branding : k => v.managed_login_branding_id
  } : {}
}
