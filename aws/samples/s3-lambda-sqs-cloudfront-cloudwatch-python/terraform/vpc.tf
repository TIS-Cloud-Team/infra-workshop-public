
# Create a new VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    {
      Name = "vpc-${local.app_name}"
    },
    local.global_tags
  )
}

# Create an internet gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = merge(
    {
      Name = "igw-${local.app_name}"
    },
    local.global_tags
  )
}

# Create a public subnet
resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name = "subnet-public-${local.app_name}"
    },
    local.global_tags
  )
}

# Create a private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = merge(
    {
      Name = "subnet-private-${local.app_name}"
    },
    local.global_tags
  )
}

# Create a route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = merge(
    {
      Name = "rt-${local.app_name}"
    },
    local.global_tags
  )
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.example.id
}

# Create a security group
resource "aws_security_group" "example" {
  vpc_id      = aws_vpc.example.id
  name="${local.app_name}-sg-01"
  description = "Allow all inbound traffic"  
  tags = merge(
    {
      Name = "sg-${local.app_name}"
    },
    local.global_tags
  )
}

# Output the VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.example.id
}

# Output the Public Subnet ID
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

# Output the Private Subnet ID
output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}

# Output the Internet Gateway ID
output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.example.id
}

# Output the Security Group ID
output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.example.id
}