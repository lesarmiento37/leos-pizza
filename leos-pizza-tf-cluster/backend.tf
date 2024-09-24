terraform {
  backend "s3" {
    bucket         = "terraform-us-east-1-XxXXXXXXXXXX-state"
    key            = "terraform/leonardo-deploy-terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-us-east-1-XxXXXXXXXXXX-lock"
    #encrypt        = true
  }
}