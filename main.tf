

module aws_wordpress {
    source              = "./modules/latest"
    database_name           = "wordpress_db"   // database name
    database_user           = "wordpress_user" //database username
    // Password here will be used to create master db user.It should be chnaged later
    database_password = "PassWord4-user" //password for user database
    shared_credentials_file = "~/.aws/credentials"         //Access key and Secret key file location
    region                  = "ap-southeast-2" //sydney region
    IsUbuntu                = true             // true for ubuntu,false for linux 2  //boolean type
    // avaibility zone and their CIDR
    AZ1          = "ap-southeast-2a" // for EC2
    AZ2          = "ap-southeast-2b" //for RDS 
    AZ3          = "ap-southeast-2c" //for RDS
    VPC_cidr     = "10.0.0.0/16"     // VPC CIDR
    subnet1_cidr = "10.0.1.0/24"     // Public Subnet for EC2
    subnet2_cidr = "10.0.2.0/24"     //Private Subnet for RDS
    subnet3_cidr = "10.0.3.0/24"     //Private subnet for RDS
    PUBLIC_KEY_PATH  = "./mykey-pair.pub" // key name for ec2, make sure it is created before terrafomr apply
    PRIV_KEY_PATH    = "./mykey-pair"
    instance_type    = "t2.micro"    //type of instance
    instance_class   = "db.t2.micro" //type of RDS Instance
    root_volume_size = 22
}