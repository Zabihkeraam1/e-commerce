provider "aws" {
  region = "us-east-1"
}

# Get the default security group for your VPC
data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "vpc-0297cd44f118eae2f"  # Replace with your actual VPC ID
}

resource "aws_db_instance" "my_database" {
  identifier             = "my-postgres-instance-${random_id.suffix.hex}"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp3"
  db_name                = "mynewdatabase"
  username               = "postgres"
  password               = var.db_password
  parameter_group_name   = "default.postgres15"
  skip_final_snapshot    = true
  publicly_accessible    = true  # Changed to true for public access
  multi_az               = false

}


# Add a random suffix to ensure unique DB identifier
resource "random_id" "suffix" {
  byte_length = 4
}

output "rds_endpoint" {
  value = aws_db_instance.my_database.endpoint
}

output "rds_username" {
  value = aws_db_instance.my_database.username
}
