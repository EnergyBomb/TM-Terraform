#VPC
resource "aws_vpc" "VPC-Lode" {
  tags = {
    Name="VPC-Lode"
  }
  cidr_block = "10.0.0.0/16"
}

#Sub1
resource "aws_subnet" "Sub1" {
  tags = {
    name = "Sub1"
  }
  vpc_id = aws_vpc.VPC-Lode.id
  cidr_block = "10.0.0.0/24"
}

#Sub2
resource "aws_subnet" "Sub2" {
  tags = {
    name = "Sub2"
  }
  vpc_id = aws_vpc.VPC-Lode.id
  cidr_block = "10.0.1.0/24"
}

#IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC-Lode.id
}

#Routing Table
resource "aws_route_table" "RT" {
  tags = {
    name="RT"
  }
  vpc_id = aws_vpc.VPC-Lode.id
}

#Sub1 RT
resource "aws_route_table_association" "RT-Sub1" {
    subnet_id = aws_subnet.Sub1.id
    route_table_id = aws_route_table.RT.id
}

#IGW RT
resource "aws_route" "RT-IGW" {
    route_table_id = aws_route_table.RT.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
}

# Network Security group
resource "aws_security_group" "SG-SSH-HTTP" {
  tags = {
    name = "SG-SSH-HTTP"
  }
  vpc_id = aws_vpc.VPC-Lode.id

  #SSH
  ingress { 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP
  ingress { 
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #HTTPS
  ingress { 
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #sql
  ingress {
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}