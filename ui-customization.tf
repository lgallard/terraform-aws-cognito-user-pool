locals {
  # Create a map of client names to client IDs for UI customization lookups
  # Handle null/empty names by using the for_each key as fallback
  client_ids_map = {
    for k, c in aws_cognito_user_pool_client.client :
    coalesce(c.name, k) => c.id
  }

  # Create UI customizations map using the same fallback key format as
  # aws_cognito_user_pool_client.client so unnamed clients resolve to their IDs.
  client_ui_customizations = var.enabled ? {
    for idx, c in local.clients :
    coalesce(lookup(c, "name", null), "client_${idx}") => {
      css        = try(c.ui_customization_css, null)
      image_file = try(c.ui_customization_image_file, null)
    } if try(c.ui_customization_css, null) != null || try(c.ui_customization_image_file, null) != null
  } : {}
}

# UI customizations for specific clients
resource "aws_cognito_user_pool_ui_customization" "ui_customization" {
  for_each = local.client_ui_customizations

  client_id = local.client_ids_map[each.key]

  css        = each.value.css
  image_file = each.value.image_file

  user_pool_id = local.user_pool_id

  depends_on = [aws_cognito_user_pool_client.client]
}

# Default UI customization
resource "aws_cognito_user_pool_ui_customization" "default_ui_customization" {
  count = var.default_ui_customization_css != null || var.default_ui_customization_image_file != null ? 1 : 0

  css          = var.default_ui_customization_css
  image_file   = var.default_ui_customization_image_file
  user_pool_id = local.user_pool_id
}
