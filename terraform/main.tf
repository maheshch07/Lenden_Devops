resource "aws_security_group" "devsecops_sg" {
  name        = "devsecops-sg"
  description = "Security group for DevSecOps assignment"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   # INTENTIONALLY INSECURE
  }

  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devsecops_ec2" {
  ami                    = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (ap-south-1)
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.devsecops_sg.id]

  tags = {
    Name = "DevSecOps-Assignment"
  }
}