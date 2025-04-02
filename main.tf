locals {
  access_aws = chomp(regex("AWS_ACCESS_KEY_ID=(.*)", file("aws.env"))[0])
  secret_aws = chomp(regex("AWS_SECRET_ACCESS_KEY=(.*)", file("aws.env"))[0])
}

provider "aws" {
  region = "us-east-1"  
  access_key = local.access_aws
  secret_key = local.secret_aws
}

resource "aws_vpc" "default_vpc"{
  cidr_block = "10.0.0.0/16"  
  instance_tenancy = "default"

  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.default_vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "subnet_public"
  }
}

resource "aws_default_security_group" "default" {
    vpc_id =  aws_vpc.default_vpc.id

    ingress {
        protocol  = -1
        self      = true
        from_port = 0
        to_port   = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "MainSG"
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default_vpc.id

  tags = {
    Name = "gw_internet"
  }
}


resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.default_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {

    Name = "rt_public"
  }
}

resource "aws_route_table_association" "rt_association_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "aws_iam_role" "k8s_role" {
  name = "k8s_ebs_volume"

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

resource "aws_iam_policy" "k8s_ebs_policy" {
  name        = "k8s_ebs_policy"
  description = "Permissões para gerenciar volumes EBS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:CreateSnapshot",
          "ec2:DeleteSnapshot",
          "ec2:DescribeSnapshots"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "k8s_instance_profile" {
  name = "k8s_instance_profile"
  role = aws_iam_role.k8s_role.name
}

resource "aws_instance" "ec2_public" {
  count         = 5
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet_public.id
  key_name = aws_key_pair.deployer.id
  private_ip = "10.0.0.10${tostring(count.index)}"

  iam_instance_profile = aws_iam_instance_profile.k8s_instance_profile.name 
  tags = {
    Name = "k8s-instance-${count.index}"
  }
}

output "ec2_public_ips_output" {
  value = [for instance in aws_instance.ec2_public : instance.public_ip]
}

resource "local_file" "ec2_public_ips_file" {
  
  content  = join("\n", [for instance in aws_instance.ec2_public : instance.public_ip])
  filename = "ec2_public_ips.txt"
}
