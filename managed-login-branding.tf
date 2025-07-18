# AWS Cloud Control API provider is required for managed login branding
# Ensure awscc provider is configured in your root module when enabling this feature
resource "awscc_cognito_managed_login_branding" "branding" {
  for_each = var.enabled && var.managed_login_branding_enabled ? var.managed_login_branding : {}

  user_pool_id = local.user_pool_id
  # Support both client IDs and client names
  # First check if client_id exists in the client name map (indicating it's a name)
  # If it does, use the mapped ID; otherwise, treat it as a literal client ID
  client_id = lookup(local.client_name_to_id_map, each.value.client_id, each.value.client_id)

  # Assets configuration for branding images
  dynamic "assets" {
    for_each = lookup(each.value, "assets", [])
    content {
      bytes       = assets.value.bytes
      category    = assets.value.category
      color_mode  = assets.value.color_mode
      extension   = assets.value.extension
      resource_id = lookup(assets.value, "resource_id", null)
    }
  }

  # Settings as JSON for advanced branding configuration
  settings = lookup(each.value, "settings", null)

  # Whether to return merged resources (defaults + custom)
  return_merged_resources = lookup(each.value, "return_merged_resources", false)

  # Whether to use Cognito provided default values
  use_cognito_provided_values = lookup(each.value, "use_cognito_provided_values", false)

  depends_on = [
    aws_cognito_user_pool_client.client
  ]
}

locals {
  # Create a map of client names to client IDs for branding lookups
  client_name_to_id_map = var.enabled ? {
    for client in aws_cognito_user_pool_client.client : client.name => client.id
  } : {}
  
  # Create a map of branding configurations for outputs
  managed_login_branding_map = var.enabled && var.managed_login_branding_enabled ? {
    for k, v in awscc_cognito_managed_login_branding.branding : k => {
      id                        = v.id
      managed_login_branding_id = v.managed_login_branding_id
      client_id                 = v.client_id
      user_pool_id              = v.user_pool_id
    }
  } : {}
}
