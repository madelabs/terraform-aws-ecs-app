terraform {
  required_version = "~> 1.4.6"

  required_providers {
    aws = {
      version = "~> 5.0.0"
      source  = "hashicorp/aws"
    }
  }
}
