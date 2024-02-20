#Create AWS VPC
resource "aws_vpc" "siemensvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  #enable_classiclink   = "false"

  tags = {
    Name = " siemensvpc"
  }
}

# Public Subnets in Custom VPC
resource "aws_subnet" "siemensvpc-public-1" {
  vpc_id                  = aws_vpc. siemensvpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "siemensvpc-public-1"
  }
}

resource "aws_subnet" "siemensvpc-public-2" {
  vpc_id                  = aws_vpc. siemensvpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = " siemensvpc-public-2"
  }
}

resource "aws_subnet" "siemensvpc-public-3" {
  vpc_id                  = aws_vpc. siemensvpc.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1c"

  tags = {
    Name = " siemensvpc-public-3"
  }
}

# Private Subnets in Custom VPC
resource "aws_subnet" "siemensvpc-private-1" {
  vpc_id                  = aws_vpc. siemensvpc.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = " siemensvpc-private-1"
  }
}

resource "aws_subnet" "siemensvpc-private-2" {
  vpc_id                  = aws_vpc. siemensvpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = " siemensvpc-private-2"
  }
}

resource "aws_subnet" "siemensvpc-private-3" {
  vpc_id                  = aws_vpc.siemensvpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1c"

  tags = {
    Name = "siemensvpc-private-3"
  }
}

# Custom internet Gateway
resource "aws_internet_gateway" "siemens-gw" {
  vpc_id = aws_vpc. siemensvpc.id

  tags = {
    Name = "siemens-gw"
  }
}

#Routing Table for the Custom VPC
resource "aws_route_table" "siemens-public" {
  vpc_id = aws_vpc. siemensvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.siemens-gw.id
  }

  tags = {
    Name = "siemens-public-1"
  }
}

resource "aws_route_table_association" "siemens-public-1-a" {
  subnet_id      = aws_subnet. siemensvpc-public-1.id
  route_table_id = aws_route_table.siemens-public.id
}

resource "aws_route_table_association" "siemens-public-2-a" {
  subnet_id      = aws_subnet. siemensvpc-public-2.id
  route_table_id = aws_route_table.siemens-public.id
}

resource "aws_route_table_association" "siemens-public-3-a" {
  subnet_id      = aws_subnet. siemensvpc-public-3.id
  route_table_id = aws_route_table.siemens-public.id
}