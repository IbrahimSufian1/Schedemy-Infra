#VPC Creation
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {Name = "schedemy-vpc"}
}
#Internet Gateway creation
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {Name = "schedemy-igw"}
}
#Public Route Table and Subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {Name = "schedemy-public-routre-table"}
}
#Subnet Creation
resource "aws_subnet" "subnet_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
  tags = {Name = "schedemy-subnet-a"}
}
resource "aws_subnet" "subnet_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = true
  tags = {Name = "schedemy-subnet-b"}
}
#Associating Subnets with Route Table
resource "aws_route_table_association" "a" {
  subnet_id = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}