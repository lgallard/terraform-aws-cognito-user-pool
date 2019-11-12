resource "aws_cognito_user_pool_client" "client" {
  count           = length(local.clients)
  name            = lookup(element(local.clients, count.index), "name")
  generate_secret = lookup(element(local.clients, count.index), "generate_secret")
  user_pool_id    = aws_cognito_user_pool.pool.id

  #allowed_oauth_flows = var.client_allowed_oauth_flows
}

locals {
  clients_default = [
    {
      name            = var.client_name
      generate_secret = var.client_generate_secret
    }
  ]

  clients = length(var.clients) == 0 && (var.client_name == null || var.client_name == "") ? [] : (length(var.clients) > 0 ? var.clients : local.clients_default)


}
