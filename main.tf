resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "allevents-dev-vpc"
    },
    local.tags
  )
}

# resource "aws_instance" "django" {
#   ami                         = data.aws_ami.amazon_linux_2023.id
#   instance_type               = "t2.micro"
#   subnet_id                   = aws_subnet.private.*.id[0]
#   iam_instance_profile        = aws_iam_instance_profile.main_ec2.name
#   vpc_security_group_ids      = [aws_security_group.django.id]
#   user_data_replace_on_change = true
#   user_data                   = file("userdata.sh")

#   root_block_device {
#     volume_size           = 15
#     volume_type           = "gp3"
#     delete_on_termination = true
#   }

#   tags = merge(
#     {
#       Name = "allevents-django-ec2"
#     },
#     local.tags
#   )
# }