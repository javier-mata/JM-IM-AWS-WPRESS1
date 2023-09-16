terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "jm-im-main-backendbucket"
    key            = "core/jm-im/ec2/wp1/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "JM-IM-DynamoDB-Terraform-BackendTable"
    encrypt        = true

  }

  required_version = ">= 1.2.0"
}

locals {
  tags = {
    Workload    = "WordPress JM IM"
    Environment = "Dev"
    Terraform   = "Yes"
  }
}