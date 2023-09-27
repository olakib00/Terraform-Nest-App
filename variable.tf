# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}
# # vpc variables
variable "vpc_cidr" {
description = "vpc cidr block"
type        = string
}

variable "public_subnet_az1_cidr" {
description = "public subnet az1 cidr block"
type        = string
}

variable "public_subnet_az2_cidr" {
description = "public subnet az2 cidr block"
type        = string
}

variable "private_app_subnet_az1_cidr" {
description = "private app subnet az1 cidr block"
type        = string
}

variable "private_app_subnet_az2_cidr" {
description = "private app subnet az2 cidr block"
type        = string
}

variable "private_data_subnet_az1_cidr" {
description = "private data subnet az1 cidr block"
type        = string
}

variable "private_data_subnet_az2_cidr" {
description = "private data subnet az2 cidr block"
type        = string
}


variable "domain_name" {
  description = "datatbase instance identifier"
  type        = string
}

variable "alternative_names" {
  description = "sub domain name for an SSL certificate"
  type        = string
}

variable "record_name" {
  description = "database snapshot name"
  type        = string
}
# # sns topic variables
variable "operator_email" {
description = "a valid email address"
type        = string
}

# # rds variables

variable "db_engine" {
  description = " mysql database engine"
  type        = string
}

variable "engine_version" {
description = "database engine version"
type        = string
}

variable "multi_az_deployment" {
description = "create a standby db instance"
type        = bool
}

variable "database_instance_identifier" {
description = "A unique name for the RDS"
type        = string
}

variable "database_username" {
description = "database master username"
type        = string
}

variable "database_password" {
description = "database password"
type        = string
}

variable "database_name" {
description = "The name of the initial database to create"
type        = string
}

variable "database_instance_class" {
description = "database instance type"
type        = string
}

variable "allocated_storage" {
description = "database instance type"
type        = string
}

variable "publicly_accessible" {
description = "controls if instance is publicly accessible"
type        = bool
}

