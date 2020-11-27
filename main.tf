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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

##################################################################################
# RESOURCES
##################################################################################

# SECURITY GROUPS #

# Instance security group 
resource "aws_security_group" "instance-sg" {
  name   = "instance-sg"
  vpc_id = var.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "nginx" {
  count                       = length(var.public_subnets)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnets[count.index].id
  vpc_security_group_ids      = [aws_security_group.instance-sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = "${file("install_nginx.sh")}"
  iam_instance_profile        = aws_iam_instance_profile.s3_profile.name

  tags = {
    Name = "nginx-AZ-${count.index + 1}"
  }

}