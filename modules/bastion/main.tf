variable "provider_region" {
  default = "us-west-1"
  }
variable "vpc_id"{
default = ""
}
provider aws {
  alias  = "provider-1"
  region = var.provider_region
}

data "aws_ami" "amazon2-linux" {
  provider    = aws.provider-1
  most_recent = true
  owners      = ["amazon"] # Canonical
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_security_group" "allow_ssh" {
  provider    = aws.provider-1
  name        = "bastion-sg-${var.provider_region}"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 0
    to_port     = 22
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
resource "tls_private_key" "tfe-pkey" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}
resource "aws_key_pair" "keypair" {
  provider   = aws.provider-1
  key_name   = "keypair-${var.provider_region}"
  public_key = tls_private_key.tfe-pkey.public_key_openssh
}
resource "aws_instance" "bastion-hosts" {
  provider                    = aws.provider-1
  ami                         = data.aws_ami.amazon2-linux.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.keypair.key_name
  subnet_id                   = var.public_subnet
  associate_public_ip_address = true
}

resource "aws_network_interface_sg_attachment" "bastion-sg-atchmnt" {
  provider             = aws.provider-1
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.bastion-hosts.primary_network_interface_id
}
