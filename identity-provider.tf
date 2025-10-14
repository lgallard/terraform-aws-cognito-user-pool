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
  lifecycle {
    ignore_changes = [provider_details["ActiveEncryptionCertificate"]]
  }
}
