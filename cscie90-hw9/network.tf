#Create VPC
resource "aws_vpc" "vpc_master" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${terraform.workspace}-vpc",
    Group = "cscie90"
  }

}

#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  state = "available"
}

#Create public subnet 
resource "aws_subnet" "public_subnet" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"

  tags = {
    Name = "${terraform.workspace}-subnet",
    Group = "cscie90"
  }
}

#Create an IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_master.id

  tags = {
    Name = "${terraform.workspace}-igw",
    Group = "cscie90"
  }
}

#Create a route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_master.id

  tags = {
    Name = "${terraform.workspace}-route-table",
    Group = "cscie90"
  }
}
#Build a route to the internet
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
#Associate our public_subnet with the route to the IGW
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

#Create SG for allowing TCP/22 from anywhere, THIS IS FOR TESTING ONLY
resource "aws_security_group" "sg" {
  name        = "${terraform.workspace}-sg"
  description = "Allow TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  tags = {
    Name = "${terraform.workspace}-securitygroup",
    Group = "cscie90"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound_ipv4" {
  security_group_id = aws_security_group.sg.id
  cidr_ipv4       = "0.0.0.0/0"
  ip_protocol       = "-1"
}


#Create private subnet 
resource "aws_subnet" "private_subnet" {
  # As in Homework 4, place the private subnet to a different availability zone. 
  # This case, the second (index = 1) AZ.
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  # CIDR block is different from the public subnet
  cidr_block        = "10.0.2.0/24"

  tags = {
    Name = "${terraform.workspace}-private-subnet",
    Group = "cscie90"
  }
}

# Elastic IP 
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${terraform.workspace}-nat-eip",
    Group = "cscie90"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  # Associate this gateway with Elastic IP
  allocation_id = aws_eip.nat_eip.id
  # NAT gateway reside in the public subnet
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${terraform.workspace}-nat-gateway",
    Group = "cscie90"
  }
}

#Create a route table
resource "aws_route_table" "private_to_public_route_table" {
  vpc_id = aws_vpc.vpc_master.id

  tags = {
    Name = "${terraform.workspace}-private-to-public-route-table",
    Group = "cscie90"
  }
}

#Build a route to the NAT Gateway
resource "aws_route" "nat_route" {
  route_table_id = aws_route_table.private_to_public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
}

#Associate our public_subnet with the route to the IGW
resource "aws_route_table_association" "private_to_public_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_to_public_route_table.id
}

