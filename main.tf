/*resource "aws_vpc" "demovpc" {       # VPC
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "DemoVPC"
  }
}

data "aws_availability_zones" "az" {    # Availability zone
  state = "available"
}


resource "aws_subnet" "private_subnet" {     # Private Subnet
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = var.private_subnet
  availability_zone       = element(var.aws_availability_zones, 1)
  map_public_ip_on_launch = false
  tags = {
    "Name" = "${var.private_subnet_names}"
  }
}

resource "aws_subnet" "public_subnet" {      # Public Subnets
  count                   = length(var.public_subnet)
  vpc_id                  = aws_vpc.demovpc.id
  cidr_block              = element(var.public_subnet, count.index)
  availability_zone       = element(var.aws_availability_zones, 0)
  map_public_ip_on_launch = true
  tags = {
    "Name" = "${var.public_subnet_names[count.index]}"
  }
}

resource "aws_internet_gateway" "Internet_gw" {   # Internet Gateway
  vpc_id = aws_vpc.demovpc.id
  tags = {
    "Name" = "Internet_Gateway"
  }
}

resource "aws_eip" "elastic_ipp" {                  # Elastic IP
  vpc = true
  depends_on = [aws_internet_gateway.Internet_gw]
  tags = {
    "Name" = "Elastic_IPP"
  }
}

resource "aws_nat_gateway" "nat_gw_1" {             # NAT Gateway
  allocation_id = aws_eip.elastic_ipp.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on    = [aws_internet_gateway.Internet_gw]
  tags = {
    "Name" = "Nat_gateway_1"
  }
}



resource "aws_route_table" "Public_route_table" {   # Public Route Table
  vpc_id = aws_vpc.demovpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Internet_gw.id
  }
  tags = {
    "Name" = "Public_Route_table"
  }
} 

resource "aws_route_table" "Private_route_table_1" {     # Private Route Table 1
  vpc_id = aws_vpc.demovpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1.id
  }
  tags = {
    "Name" = "Public_Route_table_1"
  }
} 

resource "aws_route_table" "Private_route_table_2" {     # Private Route Table 2
  vpc_id = aws_vpc.demovpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_2.id
  }
  tags = {
    "Name" = "Public_Route_table_2"
  }
} 

resource "aws_route_table" "Private_route_table_3" {     # Private Route Table 3
  vpc_id = aws_vpc.demovpc.id
  route  {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_3.id
  }
  tags = {
    "Name" = "Public_Route_table_3"
  }
} 

resource "aws_route_table_association" "PublicRTassociation" {   # Public RT Association
  count = length(var.public_subnet)
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.Public_route_table.id
}

resource "aws_route_table_association" "Private_RT1_association" {  # Private RT1 Association
  count = length(var.private_subnet)
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.Private_route_table_1.id
}

resource "aws_route_table_association" "Private_RT2_association" {  # Private RT2 Association
  count = length(var.private_subnet)
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.Private_route_table_2.id
}

resource "aws_route_table_association" "Private_RT3_association" {  # Private RT3 Association
  count = length(var.private_subnet)
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.Private_route_table_3.id
}


resource "aws_security_group" "allow" {
  name        = "allow web traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.demovpc.id

  ingress {
    description = "HTTPs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Security Group"
  }
}
*/
