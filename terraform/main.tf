provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project}-vpc"
  cidr = "10.0.0.0/16"

  azs                     = ["${var.region}a", "${var.region}b"]
  public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_dns_hostnames    = true
}

data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_iam_role" "jenkins_ec2_role" {
  name = "${var.project}-jenkins-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "${var.project}-jenkins-instance-profile"
  role = aws_iam_role.jenkins_ec2_role.name
}

resource "aws_iam_policy" "jenkins_eks_access" {
  name        = "${var.project}-jenkins-eks-access"
  description = "Allow Jenkins EC2 instance to manage and read EKS cluster addons"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EksReadAndAddonAccess"
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:DescribeAddon",
          "eks:ListAddons",
          "eks:DescribeAddonVersions",
          "eks:DescribeAddonConfiguration",
          "eks:CreateAddon",
          "eks:UpdateAddon",
          "eks:DeleteAddon"
        ]
        Resource = "*"
      },
      {
        Sid    = "PassRoleForEksAddon"
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_eks_access_attach" {
  role       = aws_iam_role.jenkins_ec2_role.name
  policy_arn = aws_iam_policy.jenkins_eks_access.arn
}

output "jenkins_role_arn" {
  value = aws_iam_role.jenkins_ec2_role.arn
}

output "jenkins_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_instance_profile.name
}

resource "aws_security_group" "cicd_sg" {
  name        = "${var.project}-cicd-sg"
  description = "SG for Jenkins/Sonar/Docker demo"
  vpc_id      = module.vpc.vpc_id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Jenkins
  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SonarQube
  ingress {
    description = "SonarQube"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node exporter (si tu veux le consulter direct)
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # App container test (8081 -> nginx inside image)
  ingress {
    description = "Netflix container test"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project
    Role    = "cicd"
  }
}

resource "aws_security_group" "monitoring_sg" {
  name        = "${var.project}-monitoring-sg"
  description = "SG for Prometheus/Grafana/Node Exporter"
  vpc_id      = module.vpc.vpc_id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  # Prometheus
  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Grafana
  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Node exporter (si tu veux le consulter direct)
  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = var.project
    Role    = "monitoring"
  }
}

resource "aws_instance" "cicd" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type_cicd
  key_name               = var.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.cicd_sg.id]

  iam_instance_profile = aws_iam_instance_profile.jenkins_instance_profile.name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_size           = 40
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name    = "${var.project}-cicd"
    Project = var.project
  }
}

resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type_monitoring
  key_name               = var.key_name
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }

  root_block_device {
    volume_size           = 30
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name    = "${var.project}-monitoring"
    Project = var.project
  }
}