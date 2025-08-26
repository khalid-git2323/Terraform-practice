provider "aws" {
  region = "us-west-2"   # change if needed
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
  availability_zone       = "us-west-2a"   # change as per region
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

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -----------------------
# 5️⃣ Variable - Port to CIDR map
# -----------------------
variable "port_cidr_map" {
  description = "Map of ports to allowed CIDRs"
  type        = map(string)

  default = {
    22   = "1.2.3.4/32"     # SSH only from your IP
    80   = "0.0.0.0/0"      # HTTP from anywhere
    443  = "0.0.0.0/0"      # HTTPS from anywhere
    8080 = "10.0.0.0/16"    # App traffic from internal network
  }
}

# -----------------------
# 6️⃣ Security Group
# -----------------------
resource "aws_security_group" "devops_project_veera" {
  name        = "devops-project-veera"
  description = "Allow inbound traffic with different CIDRs per port"
  vpc_id      = aws_vpc.main.id

  ingress = [
    for port, cidr in var.port_cidr_map : {
      description      = "Inbound rule for port ${port}"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = [cidr]
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
    }
  ]
}