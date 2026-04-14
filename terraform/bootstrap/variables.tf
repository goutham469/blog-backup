variable "region" {
  type    = string
  default = "ap-south-1"
}


variable "state_bucket_name" {
  type = string
  # must be globally unique
  default = "goutham469-myspace-blog-backup-tf-state"
}


variable "lock_table_name" {
  type    = string
  default = "goutham469-myspace-blog-backup-terraform-locks"
}
