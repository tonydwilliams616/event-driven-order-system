terraform {
  backend "s3" {
    bucket  = "terraform-state-bucket-100aw1"
    key     = "event-driven-order-system/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}