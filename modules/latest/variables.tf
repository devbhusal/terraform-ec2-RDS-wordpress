variable "database_name" {}
variable "database_password" {}
variable "database_user" {}

variable "region" {}
variable "shared_credentials_file" {}
variable "IsUbuntu" {
  type    = bool
  default = true

}
variable "AZ1" {}
variable "AZ2" {}
variable "AZ3" {}
variable "VPC_cidr" {}
variable "subnet1_cidr" {}
variable "subnet2_cidr" {}
variable "subnet3_cidr" {}
variable "instance_type" {}
variable "instance_class" {}
variable "PUBLIC_KEY_PATH" {}
variable "PRIV_KEY_PATH" {}
variable "root_volume_size" {}

