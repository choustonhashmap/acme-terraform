data "terraform_remote_state" "vpc_list"{
  backend = "remote"

  config = {
  hostname = "cdh-tfe.hashicorp.fun"
  organization = "cdhouston"
  workspaces = {
    name = "acme-infra"
  }
}
}

output "vpc"{
  value = data.terraform_remote_state.vpc_list.outputs.admin-vpc-usw1
}

provider "aws"{
  alias = "usw1"
  region = "us-west-1"
}
provider "aws" {
  alias = "usw2"
  region     = "us-west-2"
}
provider "aws" {
  alias = "usw1"
  region = "us-west-1"
}
provider "aws" {
alias = "euc1"
region = "eu-central-1"
}

resource "aws_security_group" "allow_ssh" {
  provider    = aws.usw1
  name        = "bastion-us-west-1"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc_list.outputs.admin-vpc-usw1
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
