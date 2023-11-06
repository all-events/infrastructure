data "aws_availability_zones" "available_zones" {
  state = "available"
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

data "aws_route53_zone" "allevents_public" {
  name         = local.domain
  private_zone = false
}