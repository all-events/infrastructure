resource "aws_codedeploy_app" "django" {
  compute_platform = "Server"
  name             = "AllEvents-Django-Web-App"
  tags             = local.tags
}


# De facut in-place
resource "aws_codedeploy_deployment_group" "django" {
  app_name              = aws_codedeploy_app.django.name
  deployment_group_name = "allevents-django-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy.arn
  autoscaling_groups    = [aws_autoscaling_group.ecs_asg.id]

  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  load_balancer_info {
    target_group_info {
      name = aws_lb_target_group.backend.name
    }
  }
}