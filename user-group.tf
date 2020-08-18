resource "aws_cognito_user_group" "main" {
  for_each = var.user_groups

  #######
  # name: The name of the user group. The resource will only be created when at least 1 name value has been defined.
  #######
  name = each.key

  ##############
  # description: (Optional) The description of the user group.
  ##############
  description = try(each.value.description, null)

  #############
  # precedence: (Optional) The precedence of the user group.
  #############
  precedence = try(each.value.precedence, null)

  ###########
  # role_arn: (Optional) The ARN of the IAM role to be associated with the user group.
  ###########
  role_arn = try(each.value.role_arn, null)

  ###############
  # user_pool_id: The user pool ID associated with this user_group.
  ###############
  user_pool_id = aws_cognito_user_pool.pool.id
}
