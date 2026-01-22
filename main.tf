provider "aws" {
  region = "eu-north-1"
}

# creez VPN-ul
resource "aws_vpc" "vpc_lab01" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "vpc-lab01"
    Environment = "lab01"
  }
}
