
provider "aws" {
  region    = "us-east-1"
  profile   = "default"
}

# terraform {
#   required_providers {
#     aws  = "~> 4.61.0"
#   }
#   required_version = ">= 1.1.2, < 2.0.0"
#   backend "s3" {
#     bucket  = "seu-bucket"
#     key     = "path/no/bucket/terraform.tfstate"
#     region  = "us-east-1"
#     profile = "default"
#   }
# }