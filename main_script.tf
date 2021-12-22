provider "aws" {
  
  region="${var.region}"
  shared_credentials_file="${var.shared_credentials_file}"
}


# Create VPC
resource "aws_vpc" "prod-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
    
    
}

# Create Public Subnet for EC2
resource "aws_subnet" "prod-subnet-public-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.AZ1}"
    
}

# Create Private subnet for RDS
resource "aws_subnet" "prod-subnet-private-1" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false" //it makes private subnet
    availability_zone = "${var.AZ2}"
    
}

# Create second Private subnet for RDS
resource "aws_subnet" "prod-subnet-private-2" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false" //it makes private subnet
    availability_zone = "${var.AZ3}"
    
}



# Create IGW for internet connection 
resource "aws_internet_gateway" "prod-igw" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
}

# Creating Route table 
resource "aws_route_table" "prod-public-crt" {
    vpc_id = "${aws_vpc.prod-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.prod-igw.id}" 
    }
    
    
}


# Associating route tabe to public subnet
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    route_table_id = "${aws_route_table.prod-public-crt.id}"
}



//security group for EC2

resource "aws_security_group" "ec2_allow_rule" {
 
  
ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  vpc_id = "${aws_vpc.prod-vpc.id}" 
  tags = {
    Name = "allow ssh,http,https"
  }
}


# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {
  vpc_id = "${aws_vpc.prod-vpc.id}" 
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2_allow_rule.id}"]
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow ec2"
  }

}

# Create RDS Subnet group
resource "aws_db_subnet_group" "RDS_subnet_grp" {
   subnet_ids  = ["${aws_subnet.prod-subnet-private-1.id}","${aws_subnet.prod-subnet-private-2.id}"]
}

# Create RDS instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "${var.instance_class}"
  db_subnet_group_name      = "${aws_db_subnet_group.RDS_subnet_grp.id}"
  vpc_security_group_ids      =["${aws_security_group.RDS_allow_rule.id}"]
  name                 = "${var.database_name}"
  username             = "${var.database_user}"
  password             = "${var.database_password}"
  skip_final_snapshot  = true
}

# change USERDATA varible value after grabbing RDS endpoint info
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars = {
    db_username="${var.database_user}"
    db_user_password="${var.database_password}"
    db_name="${var.database_name}"
    db_RDS="${aws_db_instance.wordpressdb.endpoint}"
  }
}


# Create EC2 ( only after RDS is provisioned)
resource "aws_instance" "wordpressec2" {
  ami="${var.ami}"
  instance_type="${var.instance_type}"
  subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
  security_groups=["${aws_security_group.ec2_allow_rule.id}"]
  user_data = "${data.template_file.user_data.rendered}"
  key_name="${aws_key_pair.mykey-pair.id}"
  tags = {
    Name = "Wordpress.web"
  }

  # this will stop creating EC2 before RDS is provisioned
  depends_on = [aws_db_instance.wordpressdb]
}

// Sends your public key to the instance
resource "aws_key_pair" "mykey-pair" {
    key_name = "mykey-pair"
    public_key = "${file(var.PUBLIC_KEY_PATH)}"
}

# creating Elastic IP for EC2
resource "aws_eip" "eip" {
  instance = aws_instance.wordpressec2.id
  
}

output "IP" {
    value = aws_eip.eip.public_ip
}
output "RDS-Endpoint" {
    value = aws_db_instance.wordpressdb.endpoint
}

output "INFO" {
  value= "Wait 2 to 3 mins . WordPress provisioning is in process"
}





