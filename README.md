This terraform projects creates
 RDS databse with mysql 5.7 
 EC2 instance with wordpress pre installed and configured 
 ----------------------------------------------------------------------
 AWS FREE TRIAL friendly
 ----------------------------------------------------------------------
 Change database entries ,regions and other variable in terraform.tfvars file
 And Database password in user.tfvars file
 -------------------------------------------------------------------------
  This script is only suitable for AWS LINUX 2 so make sure you have correct region and 
  ami id in that region.

  make sure you have EC2 key already provisioned 

  user_data.tf is script for LINUX 2 and userdata(ubuntu).tpl is for Ubuntu
  if you want to install wordpress in ubuntu , change ami -id and userdata file source

  --------------------------------------------------------------------------------
  To plan 
  terraform plan -var-file="user.tfvars"

  To apply
  terraform apply -var-file="user.tfvars"

  To destroy
  terraform destroy -var-file="user.tfvars"

  ------------------------------------------------------------------



