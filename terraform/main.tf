############################
# VPC
############################
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

############################
# PRIVATE SUBNET
############################
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "lenden-private-subnet"
  }
}

############################
# SECURITY GROUP (HARDENED)
############################
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Restricted SG"
  vpc_id      = aws_vpc.main_vpc.id

  # SSH ONLY from trusted IP
  ingress {
    description = "SSH from admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["YOUR_PUBLIC_IP/32"]
  }

  # HTTP from ALB / trusted CIDR
  ingress {
    description = "App traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Restrict outbound traffic
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################
# EC2 INSTANCE (SECURE)
############################
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  tags = {
    Name = "secure-web-server"
  }
}
