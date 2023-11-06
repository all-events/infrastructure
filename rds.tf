# # # The subnet group for the RDS cluster
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = aws_subnet.private_rds.*.id
}

# # RDS Aurora Cluster configuration
resource "aws_rds_cluster" "aurora_postgres_main" {
  cluster_identifier = "allevents-aurora-cluster-dev"
  engine             = "aurora-postgresql"
  engine_version     = "15.3"
  # availability_zones        = data.aws_availability_zones.available_zones.names
  database_name           = ""
  master_username         = ""
  master_password         = ""
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  # db_cluster_instance_class = "db.t3.medium"
  skip_final_snapshot = true
  # allocated_storage         = 5
}

resource "aws_rds_cluster_instance" "aurora_postgres_writer" {
  count              = 1
  apply_immediately  = true
  identifier         = "aurora-cluster-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.aurora_postgres_main.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.aurora_postgres_main.engine
  engine_version     = aws_rds_cluster.aurora_postgres_main.engine_version
}