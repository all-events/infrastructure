resource "aws_cloudwatch_log_group" "django_app_server" {
  name = "ae-django-app-server"

  tags = merge(
    {
      ServiceName = "allevents-django-app-server-logs-cloudwatch"
    },
    local.tags
  )
}