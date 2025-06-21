terraform {
  required_version = ">= v0.38.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95"
    }
  }
}
