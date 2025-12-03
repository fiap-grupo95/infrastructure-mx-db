output "rds_endpoint" {
  description = "RDS endpoint hostname"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.postgres.port
}

output "rds_username" {
  description = "Master username"
  value       = aws_db_instance.postgres.username
}
