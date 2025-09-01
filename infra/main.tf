provider "aws" {
  region = "us-east-1"
}

# Get a list of available Availability Zones in the region
data "aws_availability_zones" "available" {}

# Create VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  depends_on = [aws_vpc.main_vpc]
}

# Create Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  depends_on = [aws_internet_gateway.main_igw]
}

# Create Public Subnet in the first available AZ
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  depends_on = [aws_vpc.main_vpc]
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id

  depends_on = [aws_subnet.public_subnet, aws_route_table.public_rt]
}

# Create Security Group allowing SSH, HTTP, and port 3000
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH, HTTP, and port 3000"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_vpc.main_vpc]
}

# Create EC2 Instance
resource "aws_instance" "web_server" {
  ami                    = "ami-0a0f1259dd1c90938"  # Make sure this AMI is valid in us-east-1
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_name

  depends_on = [aws_subnet.public_subnet, aws_security_group.web_sg]
}

# Allocate Elastic IP and attach to instance
resource "aws_eip" "web_ip" {
  instance = aws_instance.web_server.id

  depends_on = [aws_instance.web_server]
}

# Outputs
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

output "instance_public_ip" {
  value = aws_eip.web_ip.public_ip
}
