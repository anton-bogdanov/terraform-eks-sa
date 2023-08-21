terraform {
  backend "s3" {
    bucket  = ""
    key     = "state/terraform.tfstate"
    region  = "eu-south-1"
    encrypt = true
  }
}
