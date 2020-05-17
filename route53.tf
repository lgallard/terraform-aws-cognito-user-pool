locals {
  domain_parts = split(".", var.domain)
  parent_hosted_zone_parts = slice(local.domain_parts, 1, length(local.domain_parts))
  parent_hosted_zone = join(".", local.parent_hosted_zone_parts)
}

data "aws_route53_zone" "custom_domain_zone" {
  count = var.domain_certificate_arn == null ? 0 : 1

  name = local.parent_hosted_zone
}

resource "aws_route53_record" "custom_domain_subdomain" {
  count = var.domain_certificate_arn == null ? 0 : 1

  zone_id = data.aws_route53_zone.custom_domain_zone[0].zone_id
  name    = var.domain
  type    = "A"
  alias {
    name = aws_cognito_user_pool_domain.domain[0].cloudfront_distribution_arn
    // The following zone id is CloudFront.
    // See https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
