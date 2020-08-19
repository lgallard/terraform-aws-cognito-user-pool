resource "aws_cognito_resource_server" "resource" {
  for_each = var.resource_servers

  #######
  # name: A name for the resource server.
  #######
  name = each.key

  #############
  # identifier: An identifier for the resource server.
  #############
  identifier = each.value.identifier

  ########
  # scope: (Optional) A list of Authorization Scope.
  #   scope_name: (Required) The scope name.
  #   scope_description: (Required) The scope description.
  ########
  dynamic "scope" {
    for_each = each.value.scope

    content {
      scope_name        = scope.value.scope_name
      scope_description = scope.value.scope_description
    }
  }

  ###############
  # user_pool_id: (Required) The user pool the client belongs to.
  ###############
  user_pool_id = aws_cognito_user_pool.pool.id
}
