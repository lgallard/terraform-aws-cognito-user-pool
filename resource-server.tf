resource "aws_cognito_resource_server" "resource" {
  count      = length(local.servers)
  name       = lookup(element(local.servers, count.index), "name")
  identifier = lookup(element(local.servers, count.index), "description")

  #scope 
  dynamic "scope" {
    for_each = lookup(element(local.servers, count.index), "scope")
    content {
      scope_name        = lookup(scope.value, "scope_name")
      scope_description = lookup(scope.value, "scope_description")
    }
  }

  user_pool_id = aws_cognito_user_pool.pool.id
}

locals {
  servers_default = [
    {
      name       = var.resource_server_name
      identifier = var.resource_server_identifier
      scope = {
        scope_name        = var.resource_server_scope_name
        scope_description = var.resource_server_scope_description
      }
    }
  ]

  # This parses var.user_groups which is a list of objects (map), and transforms it to a tupple of elements to avoid conflict with  the ternary and local.groups_default
  servers_parsed = [for e in var.resource_servers : {
    name       = lookup(e, "name", null)
    identifier = lookup(e, "identifier", null)
    scope      = lookup(e, "scope", null)
    }
  ]

  servers = length(var.resource_servers) == 0 && (var.resource_server_name == null || var.resource_server_name == "") ? [] : (length(var.resource_servers) > 0 ? local.servers_parsed : local.servers_default)

}
