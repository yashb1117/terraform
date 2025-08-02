provider "aws" {
  region = ""
  secret_key = ""
  access_key = ""
}
resource "aws_vpc" "My-VPC" {

    cidr_block = "10.0.0/16"
  
}