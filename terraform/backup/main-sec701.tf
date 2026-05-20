terraform {

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#
# AWS Provider for LocalStack
#

provider "aws" {

  access_key = "test"
  secret_key = "test"

  region = "us-east-1"

  skip_region_validation      = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  s3_use_path_style = true

  endpoints {

    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
    iam = "http://localhost:4566"
    sts = "http://localhost:4566"
  }
}

#
# VPC
#

resource "aws_vpc" "securityplus_vpc" {

  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "securityplus-vpc"
  }
}

#
# Public Subnet
#

resource "aws_subnet" "public_subnet" {

  vpc_id     = aws_vpc.securityplus_vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "public-subnet"
  }
}

#
# Security Group
#

resource "aws_security_group" "web_sg" {

  name        = "web-security-group"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.securityplus_vpc.id

  #
  # HTTP
  #

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #
  # HTTPS
  #

  ingress {

    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #
  # SSH
  #

  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #
  # MySQL
  #

  ingress {

    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  #
  # Outbound
  #

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-security-group"
  }
}

#
# Web Server 1
#

resource "aws_instance" "webserver1" {

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webserver1"
    Role = "Web Server"
  }
}

#
# Web Server 2
#

resource "aws_instance" "webserver2" {

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webserver2"
    Role = "Web Server"
  }
}

#
# Web Server 3
#

resource "aws_instance" "webserver3" {

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webserver3"
    Role = "Web Server"
  }
}

#
# Web Server 4
#

resource "aws_instance" "webserver4" {

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "webserver4"
    Role = "Web Server"
  }
}

#
# MySQL Database Instance
#

resource "aws_instance" "mysql_database" {

  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "mysql-database"
    Role = "Database"
  }
}

#
# S3 Bucket for Logs
#

resource "aws_s3_bucket" "log_bucket" {

  bucket = "securityplus-log-storage"

  tags = {
    Name        = "securityplus-log-storage"
    Environment = "Lab"
    Purpose     = "Log Storage"
  }
}