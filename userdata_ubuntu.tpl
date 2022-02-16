#!/bin/bash
# AUTOMATIC WORDPRESS INSTALLER IN  AWS Ubuntu Server 20.04 LTS (HVM)

# varaible will be populated by terraform template
db_username=${db_username}
db_user_password=${db_user_password}
db_name=${db_name}
db_RDS=${db_RDS}

# install LAMP Server
apt update  -y
apt upgrade -y
apt update  -y
apt upgrade -y
#install apache server
apt install -y apache2
 


apt install -y php
apt install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,bcmath,json,xml,intl,zip,imap,imagick}



#and download mysql package to yum  and install mysql client from yum
apt install -y mysql-client-core-8.0

# starting apache  and register them to startup

systemctl enable --now  apache2


# Change OWNER and permission of directory /var/www
usermod -a -G www-data ubuntu
chown -R ubuntu:www-data /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# #**********************Installing Wordpress manually********************************* 
# # Download wordpress package and extract
# wget https://wordpress.org/latest.tar.gz
# tar -xzf latest.tar.gz
# cp -r wordpress/* /var/www/html/
# # Create wordpress configuration file and update database value
# cd /var/www/html
# cp wp-config-sample.php wp-config.php
# sed -i "s/database_name_here/$db_name/g" wp-config.php
# sed -i "s/username_here/$db_username/g" wp-config.php
# sed -i "s/password_here/$db_user_password/g" wp-config.php
# sed -i "s/localhost/$db_RDS/g" wp-config.php
# cat <<EOF >>/var/www/html/wp-config.php
# define( 'FS_METHOD', 'direct' );
# define('WP_MEMORY_LIMIT', '128M');
# EOF

#**********************Installing Wordpress using WP CLI********************************* 
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
wp core download --path=/var/www/html --allow-root
wp config create --dbname=$db_name --dbuser=$db_username --dbpass=$db_user_password --dbhost=$db_RDS --path=/var/www/html --allow-root --extra-php <<PHP
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '128M');
PHP




# Change permission of /var/www/html/
chown -R ubuntu:www-data /var/www/html
chmod -R 774 /var/www/html
rm /var/www/html/index.html
#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/apache2/apache2.conf
a2enmod rewrite

# restart apache

systemctl restart apache2
echo WordPress Installed

