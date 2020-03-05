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
  value = data.terraform_remote_state.vpc_list.outputs.admin-vpc-usw1.*
}

provider "aws"{
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
