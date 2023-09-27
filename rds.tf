# create database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "${var.project_name}-${var.environment}-database-subnet"
  subnet_ids  = [aws_subnet.private_data_subnet_az1.id, aws_subnet.private_data_subnet_az2.id]
  description = "subnet group for database instance"

  tags = {
    Name = "${var.project_name}-${var.environment}-database-subnet"
  }
}

# create the rds instance
resource "aws_db_instance" "database_instance" {
  engine                 = var.db_engine
  engine_version         = var.engine_version
  multi_az               = var.multi_az_deployment
  identifier             = var.database_instance_identifier
  username               = var.database_username
  password               = var.database_password
  db_name                = var.database_name
  instance_class         = var.database_instance_class
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database_security_group.id]
  availability_zone      = data.aws_availability_zones.available_zones.names[1]
  skip_final_snapshot    = true
  publicly_accessible    = false
}
