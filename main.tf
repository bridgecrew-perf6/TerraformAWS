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
  ami                    = "ami-0e472ba40eb589f49"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
               sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
               curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
               sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
               apt-cache policy docker-ce
               sudo apt install docker-ce
               docker run -d -p 3000:8080 jordanjlu/nginxsite:latest
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
