database_name = "wordpress_db" // database name
database_user = "wordpress_user" //database username
shared_credentials_file = "~/.aws" //Access key and Secret key file location
region  = "ap-southeast-2"  //sydney region
IsUbuntu = false  // true for ubuntu,false for linux 2  //boolean type

AZ1 = "ap-southeast-2a"  // avaibility zone
AZ2 = "ap-southeast-2b"
AZ3 = "ap-southeast-2c"
PUBLIC_KEY_PATH = "./mykey-pair.pub" // key name for ec2, make sure it is created before terrafomr apply
PRIV_KEY_PATH = "./mykey-pair"
instance_type = "t2.micro" //type pf instance
instance_class = "db.t2.micro"
