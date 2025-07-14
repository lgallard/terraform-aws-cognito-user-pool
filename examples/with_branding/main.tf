#
# Cognito User Pool with Managed Login Branding
#
module "aws_cognito_user_pool" {
  source = "../../"

  user_pool_name = var.user_pool_name
  user_pool_tier = var.user_pool_tier

  alias_attributes         = ["email", "preferred_username"]
  auto_verified_attributes = ["email"]

  # User pool client configuration
  clients = [
    {
      name                 = "app-client-web"
      callback_urls        = ["https://example.com/callback"]
      logout_urls          = ["https://example.com/logout"]
      default_redirect_uri = "https://example.com/callback"
      read_attributes      = ["email", "email_verified"]

      allowed_oauth_flows_user_pool_client = true
      allowed_oauth_flows                  = ["code"]
      allowed_oauth_scopes                 = ["email", "openid", "profile"]

      explicit_auth_flows = [
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
      ]

      supported_identity_providers = ["COGNITO"]
    }
  ]

  # Domain configuration
  domain = var.domain_name

  # Enable managed login branding
  managed_login_branding_enabled = true

  # Branding configuration for the web client
  managed_login_branding = {
    "web-client-branding" = {
      client_id = module.aws_cognito_user_pool.clients["app-client-web"].id

      # Assets for branding
      assets = [
        {
          bytes      = filebase64("${path.module}/assets/logo-light.png")
          category   = "FORM_LOGO"
          color_mode = "LIGHT"
          extension  = "png"
        },
        {
          bytes      = filebase64("${path.module}/assets/logo-dark.png")
          category   = "FORM_LOGO"
          color_mode = "DARK"
          extension  = "png"
        },
        {
          bytes      = filebase64("${path.module}/assets/background.jpg")
          category   = "PAGE_BACKGROUND"
          color_mode = "BROWSER_ADAPTIVE"
          extension  = "jpg"
        },
        {
          bytes      = filebase64("${path.module}/assets/favicon.ico")
          category   = "FAVICON_ICO"
          color_mode = "BROWSER_ADAPTIVE"
          extension  = "ico"
        }
      ]

      # Custom settings as JSON
      settings = jsonencode({
        "colorScheme" = {
          "light" = {
            "primary"    = "#007bff"
            "secondary"  = "#6c757d"
            "background" = "#ffffff"
          }
          "dark" = {
            "primary"    = "#0d6efd"
            "secondary"  = "#adb5bd"
            "background" = "#212529"
          }
        }
        "typography" = {
          "fontFamily" = "Arial, sans-serif"
          "fontSize"   = "16px"
        }
        "layout" = {
          "borderRadius" = "8px"
          "spacing"      = "16px"
        }
      })

      return_merged_resources = true
    }
  }

  tags = var.tags
}

# User pool domain for hosted UI
resource "aws_cognito_user_pool_domain" "main" {
  count        = var.domain_name != "" ? 1 : 0
  domain       = var.domain_name
  user_pool_id = module.aws_cognito_user_pool.id
}