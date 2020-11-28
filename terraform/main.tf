##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  profile = "liat"
  region  = var.aws_region
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
  state = "available"
}

##################################################################################
# RESOURCES
##################################################################################

# VPC

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

# SECURITY GROUPS #

# Instance security group 
resource "aws_security_group" "instance-sg" {
  name   = "instance-sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #

resource "aws_instance" "consul" {
  count                       = 3
  ami                         = "ami-00f5af38cc835166d"
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.instance-sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.describe-instances.name
  user_data                   = "${file("run_consul.sh")}"

  tags = {
    Name = "consul"
  }

}

resource "aws_instance" "nginx" {
  ami                         = "ami-00f5af38cc835166d"
  instance_type               = "t2.micro"
  availability_zone           = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids      = [aws_security_group.instance-sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = "${file("install_nginx.sh")}"
  iam_instance_profile        = aws_iam_instance_profile.describe-instances.name

  tags = {
    Name    = "consul"
    service = "nginx"
  }

}

# IAM ROLES #

resource "aws_iam_instance_profile" "describe-instances" {
  name = "ec2_DescribeInstances"
  role = aws_iam_role.ec2-describe.name
}

resource "aws_iam_role" "ec2-describe" {
  name               = "ec2-decribe"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ec2-describe" {
  name = "ec2-describe"
  role = aws_iam_role.ec2-describe.id

  policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Action":[
            "ec2:DescribeInstances",
            "ec2:DescribeTags"
         ],
         "Resource":"*"
      }
   ]
}
EOF
}