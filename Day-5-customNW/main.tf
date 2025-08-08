# Creation of VPC
resource "aws_vpc" "custvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    name = "custvpc"
  }
}

# Public Subnet
resource "aws_subnet" "cust_sub" {
  vpc_id     = aws_vpc.custvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    name = "cust-sub"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "cust_ig" {
  vpc_id = aws_vpc.custvpc.id
  tags = {
    name = "custIG"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.custvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cust_ig.id
  }
}

# Subnet Association (Public)
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.cust_sub.id
  route_table_id = aws_route_table.public.id
}

# Security Group (Public)
resource "aws_security_group" "allow_tls" {
  name   = "allow-tls"
  vpc_id = aws_vpc.custvpc.id
  tags = {
    name = "cust-sg"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public EC2 Instance
resource "aws_instance" "public" {
  ami                    = "ami-08a6efd148b1f7504"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.cust_sub.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags = {
    name = "publicec2"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.custvpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    name = "private-subnet"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  tags = {
    name = "NAT-EIP"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "cust_nat" {
  subnet_id         = aws_subnet.cust_sub.id
  connectivity_type = "public"
  allocation_id     = aws_eip.nat.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.custvpc.id
  tags = {
    name = "privateRT"
  }
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cust_nat.id
  }
}

# Subnet Association (Private)
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Private Security Group
resource "aws_security_group" "private" {
  name        = "private"
  description = "allow"
  vpc_id      = aws_vpc.custvpc.id
  tags = {
    name = "private"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Private EC2 Instance
resource "aws_instance" "private" {
  ami                    = "ami-084a7d336e816906b"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]
  tags = {
    name = "private"
  }
}
