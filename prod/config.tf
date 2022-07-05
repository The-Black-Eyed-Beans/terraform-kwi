terraform {
    required_providers {
      aws = {
          source = "hashicorp/aws"
          version = "~> 3.0"
      }
    }
}

provider "aws" {
    region = "eu-central-1"
    profile = "keshaun-prod"
}

terraform {
    backend s3 {
    }
}