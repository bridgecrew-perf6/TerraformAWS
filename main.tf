terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = ">= 1.1.0"

  cloud {
    organization = "jLucrew"

    workspaces {
      name = "github-action"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}



resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-02474d947ebba3566"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo docker run -p -d jordanjlu/nginxsite:latest
              sudo ufw allow 8080
              EOF
}

resource "aws_security_group" "web-sg" {
  # ... other configuration ...

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
