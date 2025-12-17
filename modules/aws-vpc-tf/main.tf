resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "${var.vpc_name}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name} IG"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

resource "aws_eip" "nat_gateways" {
  count = length(aws_subnet.private_subnets)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gtw"{
    count = length(aws_subnet.private_subnets)
    subnet_id     = element(aws_subnet.private_subnets, count.index).id
    allocation_id = element(aws_eip.nat_gateways , count.index).id

}

// creation of route tables 

resource "aws_route_table" "public_route"{
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
  }
}

// route table assosiation

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route.id
}


resource "aws_route_table" "private_subnets" {
  count  = length(aws_nat_gateway.nat_gtw)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = element(aws_nat_gateway.nat_gtw, count.index).id
  }

  tags = {
    Name = "Private Subnet Route Table"
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_subnets[*].id, count.index)
}

