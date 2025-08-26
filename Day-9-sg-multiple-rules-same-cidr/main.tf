provider "aws" {
  region = "us-west-2"   # change region if needed
}

# -----------------------
# 1️⃣ VPC
# -----------------------
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main-vpc"
  }
}

# -----------------------
# 2️⃣ Internet Gateway
# -----------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# -----------------------
# 3️⃣ Public Subnet
# -----------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"   # use valid AZ for your region
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

# -----------------------
# 4️⃣ Route Table + Route
# -----------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# -----------------------
# 5️⃣ Route Table Association
# -----------------------
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -----------------------
# 6️⃣ Security Group (your code)
# -----------------------
resource "aws_security_group" "devops_project_veera" {
  name        = "devops-project-veera"
  description = "Allow inbound traffic for multiple ports"
  vpc_id      = aws_vpc.main.id

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 8000, 8082, 8081] : { #this is for port in block
      description      = "Inbound rule for port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "devops-project-veera"
  }
}

# -----------------------
# 7️⃣ Example EC2 Instance
# -----------------------
resource "aws_instance" "example" {
  ami           = "ami-01102c5e8ab69fb75"   # Amazon Linux 2 AMI (update for region)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.devops_project_veera.id]

  associate_public_ip_address = true

  tags = {
    Name = "devops-instance"
  }
}
