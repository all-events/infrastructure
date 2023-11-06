# Creat the CNAME records to validate the CloudFront certificate
resource "aws_route53_record" "cloudfront_cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.allevents_public.zone_id
}

# DNS A record to point to CloudFront URL
resource "aws_route53_record" "root_alias_a" {
  zone_id = data.aws_route53_zone.allevents_public.zone_id
  name    = local.domain
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# DNS A record to point to CloudFront URL
resource "aws_route53_record" "www_root_alias_a" {
  zone_id = data.aws_route53_zone.allevents_public.zone_id
  name    = "www.${local.domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}