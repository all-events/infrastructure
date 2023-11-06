resource "aws_launch_template" "ecs_launch_template" {
  image_id               = data.aws_ami.amazon_linux_2023.id
  vpc_security_group_ids = [aws_security_group.django.id]
  user_data              = filebase64("userdata.sh")
  instance_type          = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.main_ec2.name
  }

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size           = 15
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      {
        Name       = "allevents-django-ec2",
        Deployment = "CodeDeploy"
      },
      local.tags
    )
  }
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "allevents-django-app-asg"
  vpc_zone_identifier       = aws_subnet.private.*.id
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_grace_period = 300
  health_check_type         = "EC2"
  force_delete              = false

  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = aws_launch_template.ecs_launch_template.latest_version
  }
}

resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.id
  lb_target_group_arn    = aws_lb_target_group.backend.arn
}