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
  ami                    = "ami-0c293f3f676ec4f90"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
<<<<<<< HEAD
              #!/bin/bash
               sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
               curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
               sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
               apt-cache policy docker-ce
               sudo apt install docker-ce
               docker run -d -p 3000:8080 jordanjlu/nginxsite:latest
              EOF
=======
    #!/bin/bash
    set -ex
    sudo yum update -y
    sudo amazon-linux-extras install docker -y
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo docker run -d -p 3000:80
  EOF
>>>>>>> 0fadfd5e81e6bf5677350245d856bb822dd3cb9d
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
