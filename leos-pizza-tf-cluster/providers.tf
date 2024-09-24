provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    sops = {
      source = "carlpett/sops"
    }
  }
}

provider "sops" {
}