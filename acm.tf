# # Amazon Issued certificate for CloudFront
resource "aws_acm_certificate" "cloudfront_cert" {
  provider                  = aws.acm
  domain_name               = local.domain
  subject_alternative_names = ["*.${local.domain}", "www.${local.domain}"]
  validation_method         = "DNS"

  tags = merge(
    {
      Name = "allevents-frontend-certificate"
    },
    local.tags
  )

  lifecycle {
    create_before_destroy = true
  }
}

# Create the validation resource
resource "aws_acm_certificate_validation" "cert" {

  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront_cert_validation_records : record.fqdn]
}