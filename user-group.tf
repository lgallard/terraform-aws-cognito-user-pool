resource "aws_cognito_user_group" "main" {
  count        = var.user_group_name == null || var.user_group_name == "" ? 0 : 1
  name         = var.user_group_name
  description  = var.user_group_description
  precedence   = var.user_group_precedence
  role_arn     = var.user_group_role_arn
  user_pool_id = aws_cognito_user_pool.pool.id
}
