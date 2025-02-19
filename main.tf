provider "aws" {
  region = "us-east-1"  
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

resource "aws_instance" "ec2_public" {
  count         = 5
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet_public.id
  key_name = aws_key_pair.deployer.id

  tags = {
    Name = "k8s-instance-${count.index}"
  }
}

output "ec2_public_ips" {
  value = [for instance in aws_instance.ec2_public : instance.public_ip]
}