provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "my_security_group" {
  name        = "terraform-ansible-security-group"
  description = "Security group allowing specified inbound and outbound traffic"
  vpc_id      = "vpc-04b81e43d004d4ca5"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.88.43.22/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["102.88.43.22/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.82.86/32"]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_instance" {
  ami             = "ami-07caf09b362be10b8"
  instance_type   = "t2.micro"
  subnet_id       = "subnet-0ac8a293b8c81c170"
  key_name        = "demo"
  tags = {
    EnvName = "Test Environment"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.my_instance.public_ip} >> /etc/ansible/hosts"
  }
}
