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
 module "usw1-bastion" {
   source = "./modules/bastion"
   provider_region = "us-west-1"
   vpc_id = data.terraform_remote_state.vpc_list.outputs.admin-vpc-usw1
 }

 module "usw2-bastion" {
   source = "./modules/bastion"
   provider_region = "us-west-2"
   vpc_id = data.terraform_remote_state.vpc_list.outputs.admin-vpc-usw2
 }

 module "euc1-bastion" {
   source = "./modules/bastion"
   provider_region = "eu-central-1"
   vpc_id = data.terraform_remote_state.vpc_list.outputs.admin-vpc-euc1
 }
