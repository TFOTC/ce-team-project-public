terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket         = "ce-tfotc-remote-store"
    key            = "terraform.tfstate"
    dynamodb_table = "ce-tfotc-remote-store"
    region         = "eu-west-2"
  }

}

provider "aws" {
  region = "eu-west-2"
}

