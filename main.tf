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

resource "aws_elastic_beanstalk_application" "tftest" {
  name        = "tf-test-name"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_environment" "tfenvtest" {
  name                = "tf-test-name"
  application         = "${aws_elastic_beanstalk_application.tftest.name}"
  solution_stack_name = "apache"
}
