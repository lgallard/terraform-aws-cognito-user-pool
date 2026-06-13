resource "aws_cognito_log_delivery_configuration" "this" {
  for_each = var.enabled && var.log_delivery_configuration != null ? { this = var.log_delivery_configuration } : {}

  user_pool_id = local.user_pool_id

  dynamic "log_configurations" {
    for_each = each.value.log_configurations
    content {
      event_source = log_configurations.value.event_source
      log_level    = log_configurations.value.log_level

      dynamic "cloud_watch_logs_configuration" {
        for_each = log_configurations.value.cloud_watch_logs_configuration != null ? [log_configurations.value.cloud_watch_logs_configuration] : []
        content {
          log_group_arn = cloud_watch_logs_configuration.value.log_group_arn
        }
      }

      dynamic "firehose_configuration" {
        for_each = log_configurations.value.firehose_configuration != null ? [log_configurations.value.firehose_configuration] : []
        content {
          stream_arn = firehose_configuration.value.stream_arn
        }
      }

      dynamic "s3_configuration" {
        for_each = log_configurations.value.s3_configuration != null ? [log_configurations.value.s3_configuration] : []
        content {
          bucket_arn = s3_configuration.value.bucket_arn
        }
      }
    }
  }
}
