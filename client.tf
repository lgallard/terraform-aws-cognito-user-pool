resource "aws_cognito_user_pool_client" "client" {
  for_each = var.enabled ? {
    for idx, client in local.clients :
    "${lookup(client, "name", "client")}_${idx}" => client
  } : {}

  allowed_oauth_flows                           = lookup(each.value, "allowed_oauth_flows", null)
  allowed_oauth_flows_user_pool_client          = lookup(each.value, "allowed_oauth_flows_user_pool_client", null)
  allowed_oauth_scopes                          = lookup(each.value, "allowed_oauth_scopes", null)
  auth_session_validity                         = lookup(each.value, "auth_session_validity", null)
  callback_urls                                 = lookup(each.value, "callback_urls", null)
  default_redirect_uri                          = lookup(each.value, "default_redirect_uri", null)
  explicit_auth_flows                           = lookup(each.value, "explicit_auth_flows", null)
  generate_secret                               = lookup(each.value, "generate_secret", null)
  logout_urls                                   = lookup(each.value, "logout_urls", null)
  name                                          = lookup(each.value, "name", null)
  read_attributes                               = lookup(each.value, "read_attributes", null)
  access_token_validity                         = lookup(each.value, "access_token_validity", null)
  id_token_validity                             = lookup(each.value, "id_token_validity", null)
  refresh_token_validity                        = lookup(each.value, "refresh_token_validity", null)
  supported_identity_providers                  = lookup(each.value, "supported_identity_providers", null)
  enable_propagate_additional_user_context_data = lookup(each.value, "enable_propagate_additional_user_context_data", null)
  prevent_user_existence_errors                 = lookup(each.value, "prevent_user_existence_errors", null)
  write_attributes                              = lookup(each.value, "write_attributes", null)
  enable_token_revocation                       = lookup(each.value, "enable_token_revocation", null)
  user_pool_id                                  = local.user_pool_id

  # token_validity_units
  dynamic "token_validity_units" {
    for_each = length(lookup(each.value, "token_validity_units", {})) == 0 ? [] : [lookup(each.value, "token_validity_units")]
    content {
      access_token  = lookup(token_validity_units.value, "access_token", null)
      id_token      = lookup(token_validity_units.value, "id_token", null)
      refresh_token = lookup(token_validity_units.value, "refresh_token", null)
    }
  }

  # refresh_token_rotation
  dynamic "refresh_token_rotation" {
    for_each = length(lookup(each.value, "refresh_token_rotation", {})) == 0 ? [] : [lookup(each.value, "refresh_token_rotation")]
    content {
      type                          = lookup(refresh_token_rotation.value, "type", null)
      retry_grace_period_seconds    = lookup(refresh_token_rotation.value, "retry_grace_period_seconds", null)
    }
  }

  depends_on = [
    aws_cognito_resource_server.resource,
    aws_cognito_identity_provider.identity_provider
  ]
}

locals {
  clients_default = [
    {
      allowed_oauth_flows                           = var.client_allowed_oauth_flows
      allowed_oauth_flows_user_pool_client          = var.client_allowed_oauth_flows_user_pool_client
      allowed_oauth_scopes                          = var.client_allowed_oauth_scopes
      auth_session_validity                         = var.client_auth_session_validity
      callback_urls                                 = var.client_callback_urls
      default_redirect_uri                          = var.client_default_redirect_uri
      explicit_auth_flows                           = var.client_explicit_auth_flows
      generate_secret                               = var.client_generate_secret
      logout_urls                                   = var.client_logout_urls
      name                                          = var.client_name
      read_attributes                               = var.client_read_attributes
      access_token_validity                         = var.client_access_token_validity
      id_token_validity                             = var.client_id_token_validity
      token_validity_units                          = var.client_token_validity_units
      refresh_token_validity                        = var.client_refresh_token_validity
      enable_propagate_additional_user_context_data = var.enable_propagate_additional_user_context_data
      supported_identity_providers                  = var.client_supported_identity_providers
      prevent_user_existence_errors                 = var.client_prevent_user_existence_errors
      write_attributes                              = var.client_write_attributes
      enable_token_revocation                       = var.client_enable_token_revocation
      refresh_token_rotation                        = var.client_refresh_token_rotation
    }
  ]

  # This parses vars.clients which is a list of objects (map), and transforms it to a tuple of elements to avoid conflict with  the ternary and local.clients_default
  clients_parsed = [for e in var.clients : {
    allowed_oauth_flows                           = lookup(e, "allowed_oauth_flows", null)
    allowed_oauth_flows_user_pool_client          = lookup(e, "allowed_oauth_flows_user_pool_client", null)
    allowed_oauth_scopes                          = lookup(e, "allowed_oauth_scopes", null)
    auth_session_validity                         = lookup(e, "auth_session_validity", null)
    callback_urls                                 = lookup(e, "callback_urls", null)
    default_redirect_uri                          = lookup(e, "default_redirect_uri", null)
    explicit_auth_flows                           = lookup(e, "explicit_auth_flows", null)
    generate_secret                               = lookup(e, "generate_secret", null)
    logout_urls                                   = lookup(e, "logout_urls", null)
    name                                          = lookup(e, "name", null)
    read_attributes                               = lookup(e, "read_attributes", null)
    access_token_validity                         = lookup(e, "access_token_validity", null)
    id_token_validity                             = lookup(e, "id_token_validity", null)
    refresh_token_validity                        = lookup(e, "refresh_token_validity", null)
    enable_propagate_additional_user_context_data = lookup(e, "enable_propagate_additional_user_context_data", null)
    token_validity_units                          = lookup(e, "token_validity_units", {})
    supported_identity_providers                  = lookup(e, "supported_identity_providers", null)
    prevent_user_existence_errors                 = lookup(e, "prevent_user_existence_errors", lookup(e, "client_prevent_user_existence_errors", null))
    write_attributes                              = lookup(e, "write_attributes", null)
    enable_token_revocation                       = lookup(e, "enable_token_revocation", null)
    refresh_token_rotation                        = lookup(e, "refresh_token_rotation", {})
    }
  ]

  clients = length(var.clients) == 0 && (var.client_name == null || var.client_name == "") ? [] : (length(var.clients) > 0 ? local.clients_parsed : local.clients_default)

}
