provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

resource "aws_db_instance" "my_database" {
  identifier             = "my-database-instance"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro" # Free tier eligible
  allocated_storage      = 20
  max_allocated_storage  = 100 # Allows automatic scaling up to 100GB
  storage_type           = "gp2"
  db_name                = "mydatabase"
  username               = "admin"
  password               = var.db_password # Should be passed via variables or secrets
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true # Set to false for production
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow inbound access to RDS"

  ingress {
    from_port   = 3306
    to_port     = 3306
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

# Subnet group for RDS
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids # Pass your subnet IDs as a variable

  tags = {
    Name = "RDS Subnet Group"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.my_database.endpoint
}

output "rds_username" {
  value = aws_db_instance.my_database.username
}