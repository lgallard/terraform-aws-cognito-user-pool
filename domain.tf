resource "aws_cognito_user_pool_domain" "domain" {
  count                 = !var.enabled || var.domain == null || var.domain == "" ? 0 : 1
  domain                = var.domain
  certificate_arn       = var.domain_certificate_arn
  user_pool_id          = local.user_pool_id
  managed_login_version = var.domain_managed_login_version
}
