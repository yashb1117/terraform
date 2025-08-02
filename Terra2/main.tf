# AWS Provider Configuration
provider "aws" {
region = "us-east-1"
access_key=""
secret_key=""
}
# VPC Configuration
resource "aws_vpc" "TF2" {
  cidr_block= "10.0.0.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true 
  tags =  {
    Name = "TF2-VPC"
  }
}

# Subnet Configuration
resource "aws_subnet" "YS1" {
  vpc_id=aws_vpc.TF2.id
  availability_zone = "us-east-1a"
  cidr_block="10.0.0.0/26"
  map_public_ip_on_launch = true
}
# Internet Gateway Configuration
resource "aws_internet_gateway" "IGW" {
vpc_id=aws_vpc.TF2.id
}
# Route Table Configuration
resource "aws_route_table" "RT1" {
  vpc_id=aws_vpc.TF2.id
}

# Route Configuration
resource "aws_route" "dfg"{
route_table_id = aws_route_table.RT1.id
destination_cidr_block = "0.0.0.0/0"  
gateway_id=aws_internet_gateway.IGW.id
}

# Subnet Route Table Association
resource "aws_route_table_association" "YS1-RT1" {
  subnet_id      = aws_subnet.YS1.id
  route_table_id = aws_route_table.RT1.id
}

# EC2 Instance Configuration
resource "aws_instance" "TF2EC2" {
  ami= "ami-08a6efd148b1f7504"
  instance_type = "t2.medium"
  key_name= "git"
  subnet_id =aws_subnet.YS1.id
  availability_zone = "us-east-1a"
  security_groups = ["New same vpc"]

root_block_device {
    volume_size = 30
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags = {
    Name = "TF2-EC2"
  }
  #server script to install Apache and PHP
  user_data = file("server-script.sh")
}
#output for Public IP
output "publicIP" {
  value = aws_instance.TF2EC2.public_ip
  description = "Public IP of the EC2 instance"

}
