# Managed login branding is provided by the native AWS provider resource.
# The module input keeps the legacy `assets` name for backward compatibility,
# while the provider resource exposes repeatable `asset` blocks.
resource "aws_cognito_managed_login_branding" "branding" {
  for_each = var.enabled && var.managed_login_branding_enabled ? var.managed_login_branding : {}

  user_pool_id = local.user_pool_id
  # Support both client IDs and client names with proper resolution.
  # Try to look up the value in the client name map first.
  # If not found, treat it as a literal client ID.
  client_id = try(local.client_name_to_id_map[each.value.client_id], each.value.client_id)

  dynamic "asset" {
    for_each = try(each.value.assets, [])

    content {
      bytes       = asset.value.bytes
      category    = asset.value.category
      color_mode  = asset.value.color_mode
      extension   = upper(asset.value.extension)
      resource_id = try(asset.value.resource_id, null)
    }
  }

  # Settings is mutually exclusive with use_cognito_provided_values in the native
  # provider. Prefer explicit settings when supplied, and otherwise pass through
  # the default-values flag for users who want Cognito's provided style.
  settings                    = try(each.value.settings, null)
  use_cognito_provided_values = try(each.value.settings, null) != null ? null : try(each.value.use_cognito_provided_values, false)

  depends_on = [
    aws_cognito_user_pool_client.client
  ]
}

locals {
  # Create a map of client names to client IDs for branding lookups.
  # Handle null/empty names by using the for_each key as fallback.
  client_name_to_id_map = var.enabled ? {
    for k, client in aws_cognito_user_pool_client.client :
    coalesce(client.name, k) => client.id
  } : {}

  # Create a map of branding configurations for outputs.
  managed_login_branding_map = var.enabled && var.managed_login_branding_enabled ? {
    for k, v in aws_cognito_managed_login_branding.branding : k => {
      id                        = v.id
      managed_login_branding_id = v.managed_login_branding_id
      client_id                 = v.client_id
      user_pool_id              = v.user_pool_id
    }
  } : {}
}
