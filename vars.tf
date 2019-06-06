variable "AWS_SECRET_KEY" {}
variable "AWS_ACCESS_KEY" {}
variable "AWS_REGION" {
  default = "us-east-2"
}

variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-020a9a7369c26052b"
    us-east-2 = "ami-be7753db"
    us-west-1 = "ami-0cb9ad1491169312b"
  }
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "devkey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "devkey.pub"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
