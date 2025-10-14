resource "aws_cognito_user_pool_client" "client" {
  for_each = var.enabled ? {
    for idx, client in local.clients :
    "${try(client.name, "client")}_${idx}" => client
  } : {}

  allowed_oauth_flows                           = try(each.value.allowed_oauth_flows, null)
  allowed_oauth_flows_user_pool_client          = try(each.value.allowed_oauth_flows_user_pool_client, null)
  allowed_oauth_scopes                          = try(each.value.allowed_oauth_scopes, null)
  auth_session_validity                         = try(each.value.auth_session_validity, null)
  callback_urls                                 = try(each.value.callback_urls, null)
  default_redirect_uri                          = try(each.value.default_redirect_uri, null)
  explicit_auth_flows                           = try(each.value.explicit_auth_flows, null)
  generate_secret                               = try(each.value.generate_secret, null)
  logout_urls                                   = try(each.value.logout_urls, null)
  name                                          = try(each.value.name, null)
  read_attributes                               = try(each.value.read_attributes, null)
  access_token_validity                         = try(each.value.access_token_validity, null)
  id_token_validity                             = try(each.value.id_token_validity, null)
  refresh_token_validity                        = try(each.value.refresh_token_validity, null)
  supported_identity_providers                  = try(each.value.supported_identity_providers, null)
  enable_propagate_additional_user_context_data = try(each.value.enable_propagate_additional_user_context_data, null)
  prevent_user_existence_errors = coalesce(
    try(each.value.prevent_user_existence_errors, null),
    try(each.value.client_prevent_user_existence_errors, null)
  )
  write_attributes        = try(each.value.write_attributes, null)
  enable_token_revocation = try(each.value.enable_token_revocation, null)
  user_pool_id            = local.user_pool_id

  # token_validity_units
  dynamic "token_validity_units" {
    for_each = (try(each.value.token_validity_units, null) != null &&
      length(keys(try(each.value.token_validity_units, {}))) > 0 ?
    [try(each.value.token_validity_units, {})] : [])
    content {
      access_token  = try(token_validity_units.value.access_token, null)
      id_token      = try(token_validity_units.value.id_token, null)
      refresh_token = try(token_validity_units.value.refresh_token, null)
    }
  }

  # refresh_token_rotation
  dynamic "refresh_token_rotation" {
    for_each = (try(each.value.refresh_token_rotation, null) != null &&
      length(keys(try(each.value.refresh_token_rotation, {}))) > 0 ?
    [try(each.value.refresh_token_rotation, {})] : [])
    content {
      feature                    = try(refresh_token_rotation.value.feature, null)
      retry_grace_period_seconds = try(refresh_token_rotation.value.retry_grace_period_seconds, null)
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
    allowed_oauth_flows                           = try(e.allowed_oauth_flows, null)
    allowed_oauth_flows_user_pool_client          = try(e.allowed_oauth_flows_user_pool_client, null)
    allowed_oauth_scopes                          = try(e.allowed_oauth_scopes, null)
    auth_session_validity                         = try(e.auth_session_validity, null)
    callback_urls                                 = try(e.callback_urls, null)
    default_redirect_uri                          = try(e.default_redirect_uri, null)
    explicit_auth_flows                           = try(e.explicit_auth_flows, null)
    generate_secret                               = try(e.generate_secret, null)
    logout_urls                                   = try(e.logout_urls, null)
    name                                          = try(e.name, null)
    read_attributes                               = try(e.read_attributes, null)
    access_token_validity                         = try(e.access_token_validity, null)
    id_token_validity                             = try(e.id_token_validity, null)
    refresh_token_validity                        = try(e.refresh_token_validity, null)
    enable_propagate_additional_user_context_data = try(e.enable_propagate_additional_user_context_data, null)
    token_validity_units                          = try(e.token_validity_units, {})
    supported_identity_providers                  = try(e.supported_identity_providers, null)
    prevent_user_existence_errors = coalesce(
      try(e.prevent_user_existence_errors, null),
      try(e.client_prevent_user_existence_errors, null)
    )
    write_attributes        = try(e.write_attributes, null)
    enable_token_revocation = try(e.enable_token_revocation, null)
    refresh_token_rotation  = try(e.refresh_token_rotation, {})
    }
  ]

  clients = length(var.clients) == 0 && (var.client_name == null || var.client_name == "") ? [] : (length(var.clients) > 0 ? local.clients_parsed : local.clients_default)

}
