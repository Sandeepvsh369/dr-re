resource "aws_vpc" "provpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "Provpc"
  }
}

resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.provpc.id
  tags = {
    "Name" = "Pro Igw"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.provpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Igw.id
  }
  tags = {
    "Name" = "Route"
  }
}

resource "aws_subnet" "prosubnet" {
  vpc_id            = aws_vpc.provpc.id
  cidr_block        = "10.0.18.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    "Name" = "Pro Subnet"
  }
}

resource "aws_route_table_association" "rt_asso" {
  subnet_id      = aws_subnet.prosubnet.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "allow" {
  name        = "allow web traffic"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.provpc.id

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
    Name = "Pro Security Group"
  }
}

resource "aws_network_interface" "network" {
  subnet_id       = aws_subnet.prosubnet.id
  private_ips     = ["10.0.18.9"]
  security_groups = [aws_security_group.allow.id]
}

resource "aws_eip" "myeip" {
  vpc                       = true
  network_interface         = aws_network_interface.network.id
  associate_with_private_ip = "10.0.18.9"
  depends_on                = [aws_internet_gateway.Igw]
  tags = {
    "Name" = "MyEIP"
  }
}

output "server_private_ip" {
  value = aws_eip.myeip.private_ip
}

resource "aws_instance" "webinstance" {
  ami           = "ami-0756a1c858554433e"
  instance_type = "t2.micro"
  key_name      = "Devops"
  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = "${self.public_ip}"
  }

  tags = {
    "Name" = "DemoInstance"
  }
}



