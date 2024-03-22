locals {
  client_ids_map = { for c in aws_cognito_user_pool_client.client : c.name => c.id }

  client_ui_customizations = { for c in var.clients : c.name => {
    css        = lookup(c, "ui_customization_css", null)
    image_file = lookup(c, "ui_customization_image_file", null)
    } if lookup(c, "ui_customization_css", null) != null || lookup(c, "ui_customization_image_file", null) != null
  }
}

resource "aws_cognito_user_pool_ui_customization" "ui_customization" {
  for_each = local.client_ui_customizations

  client_id = local.client_ids_map[each.key]

  css        = each.value.css
  image_file = each.value.image_file

  user_pool_id = aws_cognito_user_pool.pool[0].id
}
