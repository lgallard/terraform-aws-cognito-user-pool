output "id" {
  description = "The id of the user pool"
  value       = aws_cognito_user_pool.pool.id
}

output "arn" {
  description = "The ARN of the user pool"
  value       = aws_cognito_user_pool.pool.arn
}

output "endpoint" {
  description = "The endpoint name of the user pool. Example format: cognito-idp.REGION.amazonaws.com/xxxx_yyyyy"
  value       = aws_cognito_user_pool.pool.endpoint
}

output "creation_date" {
  description = "The date the user pool was created"
  value       = aws_cognito_user_pool.pool.creation_date
}

output "last_modified_date" {
  description = "The date the user pool was last modified"
  value       = aws_cognito_user_pool.pool.last_modified_date
}

#
# aws_cognito_user_pool_domain
#
output "domain_aws_account_id" {
  description = "The AWS account ID for the user pool owner"
  value       = join("", aws_cognito_user_pool_domain.domain.*.aws_account_id)
}

output "domain_cloudfront_distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = join("", aws_cognito_user_pool_domain.domain.*.cloudfront_distribution_arn)
}

output "domain_s3_bucket" {
  description = "The S3 bucket where the static files for this domain are stored"
  value       = join("", aws_cognito_user_pool_domain.domain.*.s3_bucket)
}

output "domain_app_version" {
  description = "The app version"
  value       = join("", aws_cognito_user_pool_domain.domain.*.version)
}

#
# aws_cognito_user_pool_client
#
output "client_ids" {
  description = "The ids of the user pool clients"
  value       = aws_cognito_user_pool_client.client.*.id
}

output "client_secrets" {
  description = " The client secrets of the user pool clients"
  value       = aws_cognito_user_pool_client.client.*.client_secret
}

#
# aws_cognito_resource_servers
#
output "resource_servers_scope_identifiers" {
  description = " A list of all scopes configured in the format identifier/scope_name"
  value       = aws_cognito_resource_server.resource.*.scope_identifiers
}
