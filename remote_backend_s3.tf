terraform {
  backend "s3" {
    bucket = "terraform-jenkins-setup"
    key = "1_Terraform_Jenkins_Setup\remote_backend_s3.tf"
    region = "ap-south-1"
  }
}