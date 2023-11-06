locals {
  tags = {
    Environment = "DEV"
    Project     = "AllEvents"
    ManagedBy   = "Terraform"
  }

  domain       = "all-events.ro"
  s3_origin_id = "CFS3Origin"
}