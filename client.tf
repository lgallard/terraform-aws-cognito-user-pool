resource "aws_cognito_user_pool_client" "client" {
  for_each = var.clients

  #######
  # name: (Required) The name of the application client. The resource will only be created when at least 1 name value has been defined.
  #######
  name = each.key

  ######################
  # allowed_oauth_flows: (Optional) List of allowed OAuth flows (code, implicit, client_credentials).
  ######################
  allowed_oauth_flows = try(each.value.allowed_oauth_flows, null)

  #######################################
  # allowed_oauth_flows_user_pool_client: (Optional) Whether the client is allowed to follow the OAuth protocol when interacting with Cognito user pools.
  #######################################
  allowed_oauth_flows_user_pool_client = try(each.value.allowed_oauth_flows_user_pool_client, null)

  #######################
  # allowed_oauth_scopes: (Optional) List of allowed OAuth scopes (phone, email, openid, profile, and aws.cognito.signin.user.admin).
  #######################
  allowed_oauth_scopes = try(each.value.allowed_oauth_scopes, null)

  ################
  # callback_urls: (Optional) List of allowed callback URLs for the identity providers.
  ################
  callback_urls = try(each.value.callback_urls, null)

  #######################
  # default_redirect_uri: (Optional) The default redirect URI. Must be in the list of callback URLs.
  #######################
  default_redirect_uri = try(each.value.default_redirect_uri, null)

  ######################
  # explicit_auth_flows: (Optional) List of authentication flows (ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, ALLOW_REFRESH_TOKEN_AUTH).
  ######################
  explicit_auth_flows = try(each.value.explicit_auth_flows, null)

  ##################
  # generate_secret: (Optional) Should an application secret be generated.
  ##################
  generate_secret = try(each.value.generate_secret, null)

  ##############
  # logout_urls: (Optional) List of allowed logout URLs for the identity providers.
  ##############
  logout_urls = try(each.value.logout_urls, null)

  ################################
  # prevent_user_existence_errors: (Optional) Choose which errors and responses are returned by Cognito APIs during authentication, account confirmation, and password recovery when the user does not exist in the user pool. When set to ENABLED and the user does not exist, authentication returns an error indicating either the username or password was incorrect, and account confirmation and password recovery return a response indicating a code was sent to a simulated destination. When set to LEGACY, those APIs will return a UserNotFoundException exception if the user does not exist in the user pool.
  ################################
  prevent_user_existence_errors = try(each.value.prevent_user_existence_errors, null)

  ##################
  # read_attributes: (Optional) List of user pool attributes the application client can read from.
  ##################
  read_attributes = try(each.value.read_attributes, null)

  #########################
  # refresh_token_validity: (Optional) The time limit in days refresh tokens are valid for.
  #########################
  refresh_token_validity = try(each.value.refresh_token_validity, null)

  ###############################
  # supported_identity_providers: (Optional) List of provider names for the identity providers that are supported on this client.
  ###############################
  supported_identity_providers = try(each.value.supported_identity_providers, null)

  ###################
  # write_attributes: (Optional) List of user pool attributes the application client can write to.
  ###################
  write_attributes = try(each.value.write_attributes, null)

  ###############
  # user_pool_id: (Required) The user pool the client belongs to.
  ###############
  user_pool_id = aws_cognito_user_pool.pool.id
}
