terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Use default VPC and its default subnets for simplicity
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-default-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
  tags = {
    Name = "rds-default-subnet-group"
  }
}

# Parameter group for Postgres with SSL not forced (rds.force_ssl = 0)
resource "aws_db_parameter_group" "postgres" {
  name   = "mecanica-xpto-postgres-17-params"
  family = "postgres17"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }
}

# Security Group allowing Postgres access from configured CIDRs and EKS SG
resource "aws_security_group" "rds" {
  name        = "rds-postgres-sg"
  description = "Allow Postgres access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Postgres from allowed CIDRs"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  dynamic "ingress" {
    for_each = var.eks_security_group_id == "" ? [] : [var.eks_security_group_id]
    content {
      description     = "Postgres from EKS SG"
      from_port       = 5432
      to_port         = 5432
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-postgres-sg"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "mecanica-xpto-db"
  engine                 = "postgres"
  engine_version         = var.postgres_engine_version
  parameter_group_name   = aws_db_parameter_group.postgres.name
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = true
  port                   = 5432

  db_name  = var.initial_db_name
  username = var.postgres_username
  password = var.postgres_password

  backup_retention_period      = 0
  deletion_protection          = false
  skip_final_snapshot          = true
  multi_az                     = false
  performance_insights_enabled = false

  apply_immediately = true

  tags = {
    Name    = "mx-db-postgres"
    Project = "mecanica-xpto"
  }
}
