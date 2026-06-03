terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "localstack_endpoint" {
  description = "LocalStack endpoint URL"
  type        = string
  default     = "http://localhost:7788"
}

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
    ec2 = var.localstack_endpoint
    s3  = var.localstack_endpoint
    iam = var.localstack_endpoint
    sts = var.localstack_endpoint
  }
}

# -----------------------------
# VPC
# -----------------------------

resource "aws_vpc" "securityplus_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name        = "securityplus-vpc"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Subnet
# -----------------------------

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.securityplus_vpc.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name        = "securityplus-public-subnet"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Security Group
# -----------------------------

resource "aws_security_group" "web_sg" {
  name        = "securityplus-web-security-group"
  description = "Allow web, SSH, and MySQL lab traffic"
  vpc_id      = aws_vpc.securityplus_vpc.id

  ingress {
    description = "Allow HTTP from anywhere for demo purposes"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere for demo purposes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH from anywhere for demo purposes"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow MySQL only inside the VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "securityplus-web-security-group"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Web Server 1
# -----------------------------

resource "aws_instance" "webserver1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "webserver1"
    Role        = "Web Server"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Web Server 2
# -----------------------------

resource "aws_instance" "webserver2" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "webserver2"
    Role        = "Web Server"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Web Server 3
# -----------------------------

resource "aws_instance" "webserver3" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "webserver3"
    Role        = "Web Server"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Web Server 4
# -----------------------------

resource "aws_instance" "webserver4" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "webserver4"
    Role        = "Web Server"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# MySQL Database Instance
# -----------------------------

resource "aws_instance" "mysql_database" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name        = "mysql-database"
    Role        = "Database Server"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# S3 Bucket for Log Storage
# -----------------------------

resource "aws_s3_bucket" "log_bucket" {
  bucket = "securityplus-log-storage"

  tags = {
    Name        = "securityplus-log-storage"
    Purpose     = "Log Storage"
    Environment = "SecurityPlus-Lab"
  }
}

# -----------------------------
# Outputs
# -----------------------------

output "vpc_id" {
  value = aws_vpc.securityplus_vpc.id
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "security_group_id" {
  value = aws_security_group.web_sg.id
}

output "webserver_names" {
  value = [
    aws_instance.webserver1.tags["Name"],
    aws_instance.webserver2.tags["Name"],
    aws_instance.webserver3.tags["Name"],
    aws_instance.webserver4.tags["Name"]
  ]
}

output "mysql_database_name" {
  value = aws_instance.mysql_database.tags["Name"]
}

output "log_bucket_name" {
  value = aws_s3_bucket.log_bucket.bucket
}