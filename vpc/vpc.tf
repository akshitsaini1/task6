resource "aws_vpc" "eks-vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "var.vpc_name"
  }
}

resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone= "ap-south-1a"
  map_public_ip_on_launch=true
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone= "ap-south-1b"

  map_public_ip_on_launch=true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "sub3" {
  vpc_id     = aws_vpc.eks-vpc.id
  cidr_block = "192.168.2.0/24"
  availability_zone= "ap-south-1b"

  map_public_ip_on_launch=true

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks-vpc.id

  tags = {
    Name = "demo"
  }
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.eks-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  depends_on=[aws_subnet.sub1]
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.r.id
}
resource "aws_route_table_association" "b" {
  depends_on=[aws_subnet.sub2]
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.r.id
}

resource "aws_route_table_association" "c" {
  depends_on=[aws_subnet.sub3]
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.r.id
}

output "vpc_id"{
value=aws_vpc.eks-vpc.id
}

output "sub1_id"{
    value=aws_subnet.sub1.id
}

output "sub2_id"{
    value=aws_subnet.sub2.id
}
output "sub3_id"{
    value=aws_subnet.sub3.id
}