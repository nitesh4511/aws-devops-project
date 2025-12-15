resource "aws_vpc" "devops-project" {
  cidr_block = var.cidr_range
  tags = {
   Name = "Project VPC"
 }
}

resource "aws_sub" "public-subnet" {
   vpc_id = aws_vpc.public-subnet.id
   count = length(var.public_subnet)
   cidr_block = element(var.public_subnet,count.index)
   availability_zone = element(var.availability_zones, count.index)
   tags = {
   Name = "Public Subnet ${count.index + 1}"
 }

}

resource "aws_sub" "private-subnet" {
   vpc_id = aws_vpc.private-subnet.id
   count = length(var.public_subnet)
   cidr_block = element(var.private_subnet,count.index)
   tags = {
   Name = "Private Subnet ${count.index + 1}"
 }

 availability_zone = element(var.availability_zones, count.index)
   
}

resource "aws_internet_gateway" "devops-igw" {
   vpc_id = aws_vpc.devops-project.id
}

resource "aws_route_table" "
" {
  
}

resource "aws_route_table_association" "name" {
  
}