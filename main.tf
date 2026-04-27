provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "nexmart2_vpc" {
    cidr_block = "10.0.0.0/16"
    tags       = { Name = "nexmart2-vpc" }
}

resource "aws_subnet" "nexmart2_subnet" {
    vpc_id                  = aws_vpc.nexmart2_vpc.id
    cidr_block              = "10.0.0.0/16"
    map_public_ip_on_launch = true
    availability_zone       = "ap-south-1a"
    tags                    = { Name = "nexmart2-subnet" }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.nexmart2_vpc.id
}

resource "aws_route_table" "nexmart2_rt" {
    vpc_id = aws_vpc.nexmart2_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "nexmart2_association" {
    subnet_id      = aws_subnet.nexmart2_subnet.id
    route_table_id = aws_route_table.nexmart2_rt.id
}

resource "aws_security_group" "nexmart2_sg" {
    vpc_id = aws_vpc.nexmart2_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 30080
        to_port     = 30080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "nexmart2_key" {
    key_name   = "nexmart2-key"
    public_key = file("F:/File/Devops/NexMart2/nexmart2-key.pub")
}

resource "aws_instance" "nexmart2_server" {
    ami                    = "ami-05d2d839d4f73aafb"
    instance_type          = "m7i-flex.large"
    vpc_security_group_ids = [aws_security_group.nexmart2_sg.id]
    subnet_id              = aws_subnet.nexmart2_subnet.id
    key_name               = aws_key_pair.nexmart2_key.key_name

    root_block_device {
        volume_size = 16
        volume_type = "gp3"
    }

    tags = { Nmae = "nexmar2-server" }
}
