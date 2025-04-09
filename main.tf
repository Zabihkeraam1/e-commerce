provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

resource "aws_db_instance" "my_database" {
  identifier             = "my-postgres-instance"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp3"
  db_name                = "mydatabase"
  username               = "admin"
  password               = var.db_password
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  # Removed explicit subnet group reference - will use default
  multi_az               = false
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow inbound access to RDS"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restrict to your VPC CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Removed the aws_db_subnet_group resource since we're using default

output "rds_endpoint" {
  value = aws_db_instance.my_database.endpoint
}

output "rds_username" {
  value = aws_db_instance.my_database.username
}
