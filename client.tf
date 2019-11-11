resource "aws_cognito_user_pool_client" "client" {
  count        = var.client_name == null || var.client_name == "" ? 0 : 1
  name         = var.client_name
  user_pool_id = aws_cognito_user_pool.pool.id

  allowed_oauth_flows = var.client_allowed_oauth_flows
}
