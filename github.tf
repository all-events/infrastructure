data "github_repository" "repo" {
  full_name = "all-events/infrastructure"
}

data "github_repository_environments" "repo_environment" {
  repository = "main"
}

resource "github_actions_environment_secret" "test_secret" {
  repository  = data.github_repository.repo.name
  environment = data.github_repository_environments.repo_environment.environments[0].name
  secret_name = "DOT_ENV"
  plaintext_value = templatefile("env_file_example.tpl", {
    DB_HOST     = aws_rds_cluster.aurora_postgres_main.endpoint
    DB_NAME     = aws_rds_cluster.aurora_postgres_main.database_name
    DB_USER     = aws_rds_cluster.aurora_postgres_main.master_username
    DB_PASSWORD = aws_rds_cluster.aurora_postgres_main.master_password
    DB_PORT     = aws_rds_cluster.aurora_postgres_main.port


    S3_BUCKET_NAME        = aws_s3_bucket.static.id
    AWS_ACCESS_KEY_ID     = ""
    AWS_SECRET_ACCESS_KEY = ""
  })
}