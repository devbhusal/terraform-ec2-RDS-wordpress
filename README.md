This terraform projects creates
 RDS databse with mysql 5.7 
 #EC2 instance with wordpress pre installed and configured 
 ----------------------------------------------------------------------
 AWS FREE TRIAL friendly
 ----------------------------------------------------------------------
 Change database entries ,regions and other variable in terraform.tfvars file
 And Database password in user.tfvars file
 -------------------------------------------------------------------------
  This script is default for Ubuntu   
  If you want to configure wordpress in AWS LINUX 2 then change IsUbuntu value to false in terraform.tfvars

  Make sure you have configured aws CLI in your local machine

  user_data.tf is script for LINUX 2 and userdata_ubuntu.tpl is for Ubuntu
  ----------------------------------------------------------------------------------------
  ami-id will be imported using data.aws_ami 
  --------------------------------------------------------------------------------
 <h3> Security: </h3>
<p> EC2 will be launched in public subnet and RDS will be launched in private subnet </p>
<p> Only EC2 with defined security group can access RDS and RDS wont have internet access </p>


<----------------------------------------------------------------------------------------------------------------------->

<h2> Prerequisite </h2>
<p> Before launching Terraform template, aws cli should be installed and configured with proper access key and secret key </p>
<p> Terraform should be installed in your local machine </p>
<p> Configure AWS CLI with <code> aws configure </code> if you havent configured already </p>

<------------------------------------------------------------------------------------------------------------------------>

<h2> STEPS: </h2>

 <p>Clone this repo using command <code>  git clone https://github.com/devbhusal/terraform-ec2-RDS-wordpress.git</code></p>
 <p> Go to project folder         <code>  cd terraform-ec2-RDS-wordpress </code></p>
 <p>Initialize terraform          <code>  terraform init</code></p>
 <p>Change database and aws setting in terraform.tfvars file </p>
 <p>Generate Key pair using        <code> ssh-keygen -f mykey-pair  </code></p>
 <p>View Plan using                <code> terraform plan -var-file="user.tfvars"  </code></p>
 <p>Apply the plan using           <code> terraform apply -var-file="user.tfvars" </code></p>
 
 <p> After successfull provisioning of AWS Resources,Using remote-exec and private key, EC2 instance will be connected via  SSH. Tail command will used to check prgress of Wordpress Installation. Once Installation is done ,You will be provided with Public Ip address of WebServer.</p>
 <h3> everything is Automatic. This will provision all needed  aws resources and also build and start webserver using USERDATA </h3>

 <p>Destroy the resources          <code> terraform destroy -var-file="user.tfvars" </code></p>




