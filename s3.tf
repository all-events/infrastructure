##############################
# Static website configuration
resource "aws_s3_bucket" "frontend" {
  bucket        = "allevents-react-app-code-dev"
  force_destroy = true

  tags = local.tags
}

# Public access configuration
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket static website configuration
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "allow_access_frontend" {
  bucket = aws_s3_bucket.frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AddPerm"
        Effect    = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "${aws_s3_bucket.frontend.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend]
}

# TBD
# resource "aws_s3_bucket_cors_configuration" "frontend" {
#   bucket = aws_s3_bucket.frontend.id

#   cors_rule {
#     allowed_headers = ["*"]
#     allowed_methods = ["PUT", "POST"]
#     allowed_origins = ["https://s3-website-test.allevents.ro"]
#     expose_headers  = ["ETag"]
#     max_age_seconds = 3000
#   }

#   cors_rule {
#     allowed_methods = ["GET"]
#     allowed_origins = ["*"]
#   }
# }

##########################
# Application layer bucket
resource "aws_s3_bucket" "static" {
  bucket        = "allevents-django-static-dev"
  force_destroy = true

  tags = local.tags
}

# Public access configuration
resource "aws_s3_bucket_public_access_block" "static" {
  bucket = aws_s3_bucket.static.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "static" {
  bucket = aws_s3_bucket.static.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "static" {
  depends_on = [aws_s3_bucket_ownership_controls.static]

  bucket = aws_s3_bucket.static.id
  acl    = "private"
}

# Bucket policy
# resource "aws_s3_bucket_policy" "static_allow_access" {
#   bucket = aws_s3_bucket.frontend.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "AddPerm"
#         Effect    = "Allow"
#         Principal = "*"
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket"
#         ]
#         Resource = [
#           "${aws_s3_bucket.static.arn}",
#           "${aws_s3_bucket.static.arn}/*"
#         ]
#       }
#     ]
#   })
# }

########################
# Django revision bucket
resource "aws_s3_bucket" "backend_revision" {
  bucket        = "allevents-django-revision-dev"
  force_destroy = true

  tags = local.tags
}

# Public access configuration
resource "aws_s3_bucket_public_access_block" "backend_revision" {
  bucket = aws_s3_bucket.backend_revision.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


##############################
# CloudFront logging S3 bucket
resource "aws_s3_bucket" "cloudfront_logging" {
  bucket        = "allevents-cloudfront-logging"
  force_destroy = true

  tags = local.tags
}

# Public access configuration
resource "aws_s3_bucket_public_access_block" "cloudfront_logging" {
  bucket = aws_s3_bucket.cloudfront_logging.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "cloudfront_logging" {
  bucket = aws_s3_bucket.cloudfront_logging.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "cloudfront_logging" {
  depends_on = [aws_s3_bucket_ownership_controls.cloudfront_logging]

  bucket = aws_s3_bucket.cloudfront_logging.id
  acl    = "private"
}