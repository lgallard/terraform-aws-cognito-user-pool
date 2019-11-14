resource "aws_cognito_user_pool_client" "client" {
  count                                = length(local.clients)
  allowed_oauth_flows                  = lookup(element(local.clients, count.index), "allowed_oauth_flows", null)
  allowed_oauth_flows_user_pool_client = lookup(element(local.clients, count.index), "allowed_oauth_flows_user_pool_client", null)
  allowed_oauth_scopes                 = lookup(element(local.clients, count.index), "allowed_oauth_scopes", null)
  callback_urls                        = lookup(element(local.clients, count.index), "callback_urls", null)
  default_redirect_uri                 = lookup(element(local.clients, count.index), "default_redirect_uri", null)
  explicit_auth_flows                  = lookup(element(local.clients, count.index), "explicit_auth_flows", null)
  generate_secret                      = lookup(element(local.clients, count.index), "generate_secret", null)
  logout_urls                          = lookup(element(local.clients, count.index), "logout_urls", null)
  name                                 = lookup(element(local.clients, count.index), "name", null)
  read_attributes                      = lookup(element(local.clients, count.index), "read_attributes", null)
  refresh_token_validity               = lookup(element(local.clients, count.index), "refresh_token_validity", null)
  supported_identity_providers         = lookup(element(local.clients, count.index), "supported_identity_providers", null)
  write_attributes                     = lookup(element(local.clients, count.index), "write_attributes", null)
  user_pool_id                         = aws_cognito_user_pool.pool.id
}

locals {
  clients_default = [
    {
      allowed_oauth_flows                  = var.client_allowed_oauth_flows
      allowed_oauth_flows_user_pool_client = var.client_allowed_oauth_flows_user_pool_client
      allowed_oauth_scopes                 = var.client_allowed_oauth_scopes
      callback_urls                        = var.client_callback_urls
      default_redirect_uri                 = var.client_default_redirect_uri
      explicit_auth_flows                  = var.client_explicit_auth_flows
      generate_secret                      = var.client_generate_secret
      logout_urls                          = var.client_logout_urls
      name                                 = var.client_name
      read_attributes                      = var.client_read_attributes
      refresh_token_validity               = var.client_refresh_token_validity
      supported_identity_providers         = var.client_supported_identity_providers
      write_attributes                     = var.client_write_attributes
    }
  ]

  # This parses vars.clients which is a list of objects (map), and transforms it to a tupple of elements to avoid conflict with  the ternary and local.clients_default
  clients_parsed = [for e in var.clients : {
    allowed_oauth_flows                  = lookup(e, "allowed_oauth_flows", null)
    allowed_oauth_flows_user_pool_client = lookup(e, "allowed_oauth_flows_user_pool_client", null)
    allowed_oauth_scopes                 = lookup(e, "allowed_oauth_scopes", null)
    callback_urls                        = lookup(e, "callback_urls", null)
    default_redirect_uri                 = lookup(e, "default_redirect_uri", null)
    explicit_auth_flows                  = lookup(e, "explicit_auth_flows", null)
    generate_secret                      = lookup(e, "generate_secret", null)
    logout_urls                          = lookup(e, "logout_urls", null)
    name                                 = lookup(e, "name", null)
    read_attributes                      = lookup(e, "read_attributes", null)
    refresh_token_validity               = lookup(e, "refresh_token_validity", null)
    supported_identity_providers         = lookup(e, "supported_identity_providers", null)
    write_attributes                     = lookup(e, "write_attributes", null)
    }
  ]

  clients = length(var.clients) == 0 && (var.client_name == null || var.client_name == "") ? [] : (length(var.clients) > 0 ? local.clients_parsed : local.clients_default)

}
