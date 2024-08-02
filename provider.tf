provider "aws" {
  region                   = "ap-south-1"             # Mumbai
  profile                  = "terraform-project-user" # IAM User
  shared_credentials_files = ["C:/Users/hesaw/.aws/credentials"]
}