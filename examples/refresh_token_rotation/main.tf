module "aws_cognito_user_pool_refresh_rotation" {
  source = "../../"

  user_pool_name           = "mypool-refresh-rotation"
  alias_attributes         = ["email"]
  auto_verified_attributes = ["email"]

  # Configure a client with refresh token rotation enabled
  clients = [
    {
      name                = "refresh-rotation-client"
      generate_secret     = true
      explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

      # Refresh token rotation configuration
      refresh_token_rotation = {
        feature                    = "ENABLED"
        retry_grace_period_seconds = 60 # Maximum 60 seconds per AWS limits
      }

      # Token validity settings
      refresh_token_validity = 30
      access_token_validity  = 60
      id_token_validity      = 60

      token_validity_units = {
        access_token  = "minutes"
        id_token      = "minutes"
        refresh_token = "days"
      }

      # Enable token revocation for enhanced security
      enable_token_revocation = true

      callback_urls = ["https://example.com/callback"]
      logout_urls   = ["https://example.com/logout"]

      read_attributes  = ["email", "name"]
      write_attributes = ["email", "name"]
    }
  ]

  # Basic configuration
  password_policy = {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
    password_history_size            = 0
  }

  tags = {
    Name        = "cognito-refresh-rotation-example"
    Environment = "development"
    Feature     = "refresh_token_rotation"
  }
}
