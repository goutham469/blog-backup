terraform {
  backend "s3" {
    bucket         = "goutham469-myspace-blog-backup-tf-state"
    key            = "blog-backup/main/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "goutham469-myspace-blog-backup-terraform-locks"
    encrypt        = true
  }
}