resource "aws_cognito_identity_provider" "identity_provider" {
  count        = var.enabled ? length(var.identity_providers) : 0
  user_pool_id = local.user_pool_id

  # Required fields: Keep lookup() to enforce presence
  provider_name = lookup(element(var.identity_providers, count.index), "provider_name")
  provider_type = lookup(element(var.identity_providers, count.index), "provider_type")

  # Optional fields: Use try() for modern syntax
  attribute_mapping = try(element(var.identity_providers, count.index).attribute_mapping, {})
  idp_identifiers   = try(element(var.identity_providers, count.index).idp_identifiers, [])
  provider_details  = try(element(var.identity_providers, count.index).provider_details, {})

  # Ignore changes to provider_details that are managed by AWS
  # AWS automatically populates ActiveEncryptionCertificate for SAML providers
  # OAuth providers may have auto-managed fields from OIDC discovery and sensitive value handling
  lifecycle {
    ignore_changes = [
      # SAML provider auto-managed fields
      provider_details["ActiveEncryptionCertificate"],

      # OAuth/OIDC provider auto-managed fields that may cause drift
      provider_details["authorize_url"],                 # May be updated via OIDC discovery
      provider_details["token_url"],                     # May be updated via OIDC discovery
      provider_details["oidc_issuer"],                   # May be updated via OIDC discovery
      provider_details["jwks_uri"],                      # Auto-populated from OIDC discovery
      provider_details["issuer"],                        # May be auto-populated
      provider_details["attributes_url"],                # Auto-populated on read (e.g. Google)
      provider_details["attributes_url_add_attributes"], # Auto-populated on read (e.g. Google)
      provider_details["token_request_method"],          # Auto-populated on read (e.g. Google)

      # Sensitive / write-only fields that cause drift due to Terraform's handling
      provider_details["client_secret"], # Sensitive field causing plan drift
      provider_details["private_key"],    # SignInWithApple: write-only, never returned by AWS
    ]
  }
}
