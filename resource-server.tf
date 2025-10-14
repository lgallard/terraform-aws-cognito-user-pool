resource "aws_cognito_resource_server" "resource" {
  count      = var.enabled ? length(local.resource_servers) : 0
  name       = element(local.resource_servers, count.index).name
  identifier = element(local.resource_servers, count.index).identifier

  #scope
  dynamic "scope" {
    for_each = element(local.resource_servers, count.index).scope
    content {
      scope_name        = scope.value.scope_name
      scope_description = scope.value.scope_description
    }
  }

  user_pool_id = local.user_pool_id
}

locals {
  resource_server_default = [
    {
      name       = var.resource_server_name
      identifier = var.resource_server_identifier
      scope = [
        {
          scope_name        = var.resource_server_scope_name
          scope_description = var.resource_server_scope_description
      }]
    }
  ]

  # This parses var.user_groups which is a list of objects (map), and transforms it to a tuple of elements to avoid conflict with  the ternary and local.groups_default
  resource_servers_parsed = [for e in var.resource_servers : {
    name       = try(e.name, null)
    identifier = try(e.identifier, null)
    scope      = try(e.scope, [])
    }
  ]

  resource_servers = length(var.resource_servers) == 0 && (var.resource_server_name == null || var.resource_server_name == "") ? [] : (length(var.resource_servers) > 0 ? local.resource_servers_parsed : local.resource_server_default)

}
