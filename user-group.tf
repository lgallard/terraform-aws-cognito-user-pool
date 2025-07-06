resource "aws_cognito_user_group" "main" {
  for_each     = var.enabled ? { for group in local.groups : group.name => group } : {}
  name         = each.key
  description  = lookup(each.value, "description", null)
  precedence   = lookup(each.value, "precedence", null)
  role_arn     = lookup(each.value, "role_arn", null)
  user_pool_id = local.user_pool_id
}

# State migration from count to for_each requires manual intervention
# Users need to run terraform state mv commands as documented in MIGRATION_GUIDE.md

locals {
  groups_default = [
    {
      name        = var.user_group_name
      description = var.user_group_description
      precedence  = var.user_group_precedence
      role_arn    = var.user_group_role_arn

    }
  ]

  # This parses var.user_groups which is a list of objects (map), and transforms it to a tuple of elements to avoid conflict with  the ternary and local.groups_default
  groups_parsed = [for e in var.user_groups : {
    name        = lookup(e, "name", null)
    description = lookup(e, "description", null)
    precedence  = lookup(e, "precedence", null)
    role_arn    = lookup(e, "role_arn", null)
    }
  ]

  groups = length(var.user_groups) == 0 && (var.user_group_name == null || var.user_group_name == "") ? [] : (length(var.user_groups) > 0 ? local.groups_parsed : local.groups_default)

}
