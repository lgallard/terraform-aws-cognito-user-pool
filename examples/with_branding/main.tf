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

  # Managed Login Branding configuration
  managed_login_branding_enabled = var.enable_branding
  managed_login_branding = var.enable_branding ? {
    "main" = {
      client_id = "app-client-web"  # Reference client by name
      assets = [
        {
          bytes      = filebase64("${path.module}/assets/logo-light.svg")
          category   = "FORM_LOGO"
          color_mode = "LIGHT"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/logo-dark.svg")
          category   = "FORM_LOGO"
          color_mode = "DARK"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/background.svg")
          category   = "PAGE_BACKGROUND"
          color_mode = "DYNAMIC"
          extension  = "SVG"
        },
        {
          bytes      = filebase64("${path.module}/assets/favicon.svg")
          category   = "FAVICON_ICO"
          color_mode = "DYNAMIC"
          extension  = "SVG"
        }
      ]
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
  } : {}

  tags = var.tags
}

# Local values for asset path validation
locals {
  required_assets = [
    "logo-light.svg",
    "logo-dark.svg",
    "background.svg",
    "favicon.svg"
  ]

  # Asset file paths for validation
  asset_paths = {
    logo_light = "${path.module}/assets/logo-light.svg"
    logo_dark  = "${path.module}/assets/logo-dark.svg"
    background = "${path.module}/assets/background.svg"
    favicon    = "${path.module}/assets/favicon.svg"
  }

  # Client ID lookup with validation
  target_client_name = "app-client-web"
}

# Branding configuration using the awscc provider directly  
# This avoids circular dependency by using the user pool ID and client ID separately
resource "awscc_cognito_managed_login_branding" "example" {
  count = var.enable_branding ? 1 : 0

  user_pool_id = module.aws_cognito_user_pool.id
  client_id    = module.aws_cognito_user_pool.client_ids_map[local.target_client_name]

  # Assets for branding
  assets = [
    {
      bytes      = filebase64(local.asset_paths.logo_light)
      category   = "FORM_LOGO"
      color_mode = "LIGHT"
      extension  = "SVG"
    },
    {
      bytes      = filebase64(local.asset_paths.logo_dark)
      category   = "FORM_LOGO"
      color_mode = "DARK"
      extension  = "SVG"
    },
    {
      bytes      = filebase64(local.asset_paths.background)
      category   = "PAGE_BACKGROUND"
      color_mode = "DYNAMIC"
      extension  = "SVG"
    },
    {
      bytes      = filebase64(local.asset_paths.favicon)
      category   = "FAVICON_ICO"
      color_mode = "DYNAMIC"
      extension  = "SVG"
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

  depends_on = [module.aws_cognito_user_pool]
}