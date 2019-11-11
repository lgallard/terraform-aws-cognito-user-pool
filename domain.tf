resource "aws_cognito_user_pool_domain" "domain" {
  count           = var.user_pool_domain == null || var.user_pool_domain == "" ? 0 : 1
  domain          = var.user_pool_domain
  certificate_arn = var.user_pool_certificate_arn
  user_pool_id    = aws_cognito_user_pool.pool.id
}
