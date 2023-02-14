# Variables
variable "key_name" {}
variable "private_key_path" {}

#Choose provider
terraform {
  required_providers {
    aws = {
      version = "~> 4.16"
      source  = "hashicorp/aws"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


#Creat VPC
resource "aws_vpc" "vpc_nginx" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"
  tags = {
      Name = "vpc_nginx"
    }
}

#Create a public subnet
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.vpc_nginx.id 
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" 
  availability_zone       = "us-east-1a"
}

#Create IGW
resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.vpc_nginx.id
}

#Create a route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_nginx.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_igw.id
  }
  tags = {
      Name = "public_rt"
    }
}
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

#Create security group
resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "allow ssh on 22 & http on port 80"
  vpc_id      = aws_vpc.vpc_nginx.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#Create EC2
resource "aws_instance" "nginx_server" {
  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"
  tags = {
      Name = "nginx_server"
  }
  subnet_id = aws_subnet.public_1.id
  vpc_security_group_ids = ["${aws_security_group.demo_sg.id}"]
  key_name               = var.key_name
  user_data              = file("nginx.tpl")
}  

#OUTPUT
output "aws_instance_public_dns" {
  value = aws_instance.nginx_server.public_dns
}
