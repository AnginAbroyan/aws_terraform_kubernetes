output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "rds_access" {
  value = var.db_sg_id
}
