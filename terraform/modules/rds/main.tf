resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = var.private_subnet
  tags       = merge(var.tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}

resource "aws_db_instance" "mysql" {
  engine                      = var.db_engine
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  allocated_storage           = var.allocated_storage
  storage_type                = var.storage_type
  identifier                  = var.db_identifier
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids      = [var.db_sg_id]
  skip_final_snapshot         = true
  storage_encrypted           = false
  tags                        = merge(var.tags,
    { Name = "${var.project_name}-VPC" })
}


