terraform {
  required_version = ">= v0.13.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.38"
    }
  }
}
