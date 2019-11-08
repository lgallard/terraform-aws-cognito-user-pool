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
