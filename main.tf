provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}
//  VPC
resource "aws_vpc" "AWS-VPC" {
  cidr_block       = "${var.vpc_cidr}"
  #instance_tenancy = "default"

  tags = {
    Name = "${var.vpcname}"
  }
}
//  SUBNETS

resource "aws_subnet" "subnet-1" {
  vpc_id     = "${aws_vpc.AWS-VPC.id}"
  cidr_block = "${var.cidr_block-1}"

  tags = {
    Name = "${var.public-subnet-1-name}"
  }
}

resource "aws_subnet" "subnet-2" {
  vpc_id     = "${aws_vpc.AWS-VPC.id}"
  cidr_block = "${var.cidr_block-2}"

  tags = {
    Name = "${var.public-subnet-2-name}"
  }
}

resource "aws_subnet" "subnet-3" {
  vpc_id     = "${aws_vpc.AWS-VPC.id}"
  cidr_block = "${var.cidr_block-3}"

  tags = {
    Name = "${var.public-subnet-3-name}"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id ="${aws_vpc.AWS-VPC.id}"

  tags = {
    Name = "${var.igwname}"
  }
}

resource "aws_route_table" "AWS-ROUTE" {
  vpc_id ="${aws_vpc.AWS-VPC.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id ="${aws_internet_gateway.IGW.id}"
  }

  
  tags = {
    Name = "${var.routetable-name}"
  }
}

resource "aws_route_table_association" "SUBNET-1" {
  subnet_id      ="${aws_subnet.subnet-1.id}"
  route_table_id ="${aws_route_table.AWS-ROUTE.id}"
}

resource "aws_route_table_association" "SUBNET-2" {
  subnet_id      ="${aws_subnet.subnet-2.id}"
  route_table_id ="${aws_route_table.AWS-ROUTE.id}"
}

resource "aws_route_table_association" "SUBNET-3" {
  subnet_id      ="${aws_subnet.subnet-3.id}"
  route_table_id ="${aws_route_table.AWS-ROUTE.id}"
}


resource "aws_security_group" "SURYA-SEC" {
  name        = "surys-SEC"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.AWS-VPC.id}"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
}



   # access_key = "AKIA2O3EDZYGOBHFSGW3"
   #secret_key = "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"
