# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "olakib-terraform-nest-state"
    key            = "nest-app/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "nest-app-terraform-state-lock"
  }
}