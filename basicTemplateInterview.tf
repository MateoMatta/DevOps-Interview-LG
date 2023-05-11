terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65.0"
    }
  }
}

provider "aws"{
    region = "us-east-1"
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.1.0.0/16"
    tags = {
    Name = "Particular VPC"
    Author = "Mateo Matta"
  }
}

resource "aws_subnet" "demo-sub-01" {
  vpc_id = aws_vpc.demo-vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone =  "us-east-1a"
  map_public_ip_on_launch = true
    tags = {
    Name = "Particular subnet for us-east-1"
    Author = "Mateo Matta"
  }
}

resource "aws_internet_gateway" "ig-demo" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "Principal Internet Gateway"
    Author = "Mateo Matta"
  }
  
}

resource "aws_route_table" "demo_route_table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig-demo.id
  }

  tags = {
    Name = "demo-rtb"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.demo-sub-01.id
  route_table_id = aws_route_table.demo_route_table.id
}

resource "aws_security_group" "demo-sg-01"{
  name        = "allow_ssh_and_web_server_ports"
  description = "Allow SSH and web ports for inbound traffic"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    description      = "Web server port from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH connection from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  #   ingress {
  #   description      = "Personal connecction from VPC to have a pre-work for the website"
  #   from_port        = 0
  #   to_port          = 0
  #   protocol         = "-1"
  #   cidr_blocks      = ["181.xxx.xxx.xxx/32"]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  tags = {
    Name = "allow_ssh_and_web_ports"
    Author = "Mateo Matta"
  }
} 

# resource "aws_instance" "my_vm" {
#   ami             = "ami-007855ac798b5175e" //Ubuntu AMI
#   instance_type   = "t2.micro"
#   key_name        = "candidate"

#   tags = {
#     Name = "My EC2 instance"
#     Author = "Mateo Matta"
#   }
# }
    # name = "demo-elb"
    # subnets = [aws_subnet.demo-sub-01.id]
    # security_groups = [aws_security_group.demo-sg-01.id]

resource "aws_autoscaling_group" "demo_autoscaling"{
    name = "demo-asg-instance-1"
    min_size = "1"
    max_size = "1"
    vpc_zone_identifier = [aws_subnet.demo-sub-01.id]
    launch_configuration = aws_launch_configuration.demo_configuration.name
    load_balancers = [aws_elb.demo-elb.name]
    tag {
        key = "Name"
        value = "demo-asg-instance-1"
        propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "demo_configuration"{
    name = "placeholder-demo-lc"
    image_id = "ami-007855ac798b5175e"
    instance_type = "t2.micro"
    security_groups = [aws_security_group.demo-sg-01.id]
    associate_public_ip_address = true
    key_name = "candidate"
    user_data = file("./awsLaunchConfiguration.sh")
}

resource "aws_elb" "demo-elb" {
    name = "demo-elb-elb"
    subnets = [aws_subnet.demo-sub-01.id]
    security_groups = [aws_security_group.demo-sg-01.id]
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }

#     #   #   listener {
#     #   #   instance_port      = 80
#     #   #   instance_protocol  = "http"
#     #   #   lb_port            = 443
#     #   #   lb_protocol        = "https"
#     #   #   ssl_certificate_id = "arn:aws:iam::016311465375:test-certificate/mateomatta"
#     #   # }

    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }
}