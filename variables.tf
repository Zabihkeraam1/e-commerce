variable "db_password" {
  description = "Password for the database admin user"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "List of subnet IDs for RDS"
  type        = list(string)
}