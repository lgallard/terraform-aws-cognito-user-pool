resource "aws_cognito_user_pool_domain" "domain" {
  count        = var.user_pool_domain == null || var.user_pool_domain == "" ? 0 : 1
  domain       = var.user_pool_domain
  user_pool_id = aws_cognito_user_pool.pool.id
}
