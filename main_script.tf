provider "aws" {
  
  region="${var.region}"
  shared_credentials_file="${var.shared_credentials_file}"
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

  tags = {
    Name = "allow ssh,http,https"
  }
}


# Security group for RDS
resource "aws_security_group" "RDS_allow_rule" {

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

# Create RDS instance
resource "aws_db_instance" "wordpressdb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
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
  security_groups=["${aws_security_group.ec2_allow_rule.name}"]
  user_data = "${data.template_file.user_data.rendered}"
  key_name="${var.key_name}"
  tags = {
    Name = "Wordpress.web"
  }

  # this will stop creating EC2 before RDS is provisioned
  depends_on = [aws_db_instance.wordpressdb]
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




