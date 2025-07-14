# AWS Cloud Control API provider is required for managed login branding
# Ensure awscc provider is configured in your root module when enabling this feature
resource "awscc_cognito_managed_login_branding" "branding" {
  for_each = var.enabled && var.managed_login_branding_enabled ? var.managed_login_branding : {}

  user_pool_id = local.user_pool_id
  client_id    = lookup(each.value, "client_id", null)

  # Assets configuration for branding images
  assets = lookup(each.value, "assets", [])

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
