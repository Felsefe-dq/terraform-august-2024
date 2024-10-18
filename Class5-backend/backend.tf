terraform {
  backend "s3" {
    bucket = "kaizen-datkaiym"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

