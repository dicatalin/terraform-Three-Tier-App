provider "aws" {
  region = "eu-north-1"
}

# creez VPN-ul
resource "aws_vpc" "vpc_lab01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "vpc-lab01"
    Environment = "lab01"
  }
}

# subretea privata 1 pentru baza de date mysql (aws te obliga sa ai doua subretele pentru db)
resource "aws_subnet" "priv_subnet1_lab01" {
  vpc_id            = aws_vpc.vpc_lab01.id
  cidr_block        = "10.0.1.0/24" # range ip utilizabile 10.0.1.1 - 10.0.1.254

  availability_zone = "eu-north-1a"

  tags = {
    Name = "priv_subnet1_lab01"
  }
}

# subretea privata 2 pentru baza de date mysql (aws te obliga sa ai doua subretele pentru db)
resource "aws_subnet" "priv_subnet2_lab01" {
  vpc_id            = aws_vpc.vpc_lab01.id
  cidr_block        = "10.0.2.0/24" # range ip utilizabile 10.0.1.1 - 10.0.1.254

  availability_zone = "eu-north-1b"

  tags = {
    Name = "priv_subnet2_lab01"
  }
}

# Grupam cele doua subretele
resource "aws_db_subnet_group" "subnet_grup01_db_lab01" {
  name       = "subnet_grup01_db_lab01"
  subnet_ids = [aws_subnet.priv_subnet1_lab01.id, aws_subnet.priv_subnet2_lab01.id]
  tags       = { Name = "subnet_grup01_db_lab01" }
}

# Instanta de mysql
resource "aws_db_instance" "mysql_db_lab01" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_name              = "books"
  username             = "admin"
  password             = var.db_password

  db_subnet_group_name = aws_db_subnet_group.subnet_grup01_db_lab01.name
  skip_final_snapshot  = true
  publicly_accessible  = false
}
