output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.rds_db.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.rds_db.port
}