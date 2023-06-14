terraform {
  required_version = "~> 1.3.3"

  required_providers {
    aws = {
      version = "~> 5.0.0"
      source  = "hashicorp/aws"
    }
  }
}
