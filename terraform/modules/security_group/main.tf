# Create security group for our db mysql
resource "aws_security_group" "db_sg" {
  description = "enable mysql access on port 3306"
  vpc_id      = var.vpc_id
  ingress {
    description = "mysql access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #    security_groups = [aws_security_group.private_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.project_name}-security-group-db" })
}