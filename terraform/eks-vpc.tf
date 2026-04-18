provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

resource "aws_vpc" "eks_vpc" {
  cidr_block           = "10.50.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-eks-vpc"
  }
}

resource "aws_internet_gateway" "eks_igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.project}-eks-igw"
  }
}

resource "aws_subnet" "eks_public_a" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.50.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project}-eks-public-a"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "eks_public_b" {
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = "10.50.2.0/24"
  availability_zone       = "${var.region}b"
  map_public_ip_on_launch = true

  tags = {
    Name                     = "${var.project}-eks-public-b"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "eks_private_a" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.50.11.0/24"
  availability_zone = "${var.region}a"

  tags = {
    Name                              = "${var.project}-eks-private-a"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "eks_private_b" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.50.12.0/24"
  availability_zone = "${var.region}b"

  tags = {
    Name                              = "${var.project}-eks-private-b"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.project}-eks-nat-eip"
  }
}

resource "aws_nat_gateway" "eks_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.eks_public_a.id

  tags = {
    Name = "${var.project}-eks-nat"
  }

  depends_on = [aws_internet_gateway.eks_igw]
}

resource "aws_route_table" "eks_public_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igw.id
  }

  tags = {
    Name = "${var.project}-eks-public-rt"
  }
}

resource "aws_route_table_association" "eks_public_a_assoc" {
  subnet_id      = aws_subnet.eks_public_a.id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table_association" "eks_public_b_assoc" {
  subnet_id      = aws_subnet.eks_public_b.id
  route_table_id = aws_route_table.eks_public_rt.id
}

resource "aws_route_table" "eks_private_rt" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.eks_nat.id
  }

  tags = {
    Name = "${var.project}-eks-private-rt"
  }
}

resource "aws_route_table_association" "eks_private_a_assoc" {
  subnet_id      = aws_subnet.eks_private_a.id
  route_table_id = aws_route_table.eks_private_rt.id
}

resource "aws_route_table_association" "eks_private_b_assoc" {
  subnet_id      = aws_subnet.eks_private_b.id
  route_table_id = aws_route_table.eks_private_rt.id
}