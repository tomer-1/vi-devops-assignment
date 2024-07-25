terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.58"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.14.0"
    }
  }
  backend "local" {
    path = "tf-state/terraform.tfstate"
  }
  ## i did not create an S3 for the state of this task, but instead used a local state
  ## this is due to terraform limitation on using variables in the main terraform section.
  ## in order to store the state in S3 you first need to create
  ## it using terraform but with a local state and then migrate the S3 state into itself
  ## for this reason, the bucket should be created and only then the state should be manually moved into it
  ## a bucket should be created using terraform and then the state should be migrated into it
  # backend "s3" {
  #   bucket = "vi-assigment-test-th"
  #   key    = "app1/eks/my"
  #   region = "eu-north-1"
  # }
}
