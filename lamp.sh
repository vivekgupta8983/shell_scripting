#!/bin/bash

#check if you are a root user
check_root()
{
if [ "$(id -u)" != "0" ]; then
    echo "Please run this script with root user or sudo privillegs"
    exit 1
fi

}

read -p 'db_root_password [secretpasswd]: ' db_root_password  
echo

read -ep 'Enter the database name:' DB_NAME
echo 

ubuntu()
{
 # Update system  
 sudo apt-get update -y  
   
 ## Install APache  
 sudo apt-get install apache2 apache2-doc apache2-mpm-prefork apache2-utils libexpat1 ssl-cert -y  
   
 ## Install PHP  
 apt-get install php libapache2-mod-php php-mysql -y  
   
 # Install MySQL database server  
 export DEBIAN_FRONTEND="noninteractive"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password password $db_root_password"  
 debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $db_root_password"  
 apt-get install mysql-server -y  
   
 # Enabling Mod Rewrite  
 sudo a2enmod rewrite  
 sudo php5enmod mcrypt  
   
 ## Install PhpMyAdmin  
 sudo apt-get install phpmyadmin -y  
   
 ## Configure PhpMyAdmin  
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  
   
 # Set Permissions  
 sudo chown -R www-data:www-data /var/www  
   
 # Restart Apache  
 sudo service apache2 restart  
}

redhat()
{
  
# Function to disable SELinux
    SE=`cat /etc/selinux/config | grep ^SELINUX= | awk -F'=' '{print $2}'`
    echo "Checking SELinux status ..."
    echo ""
    sleep 1

    if [[ "$SE" == "enforcing" ]]; then
        sed -i 's|SELINUX=enforcing|SELINUX=disabled|g' /etc/selinux/config
        echo ""
        sleep 5
    fi
# update os

yum update
yum upgrade -y
sleep 1
yum install httpd mysql-server -y
sysytemctl restart httpd
temp_pass=$(grep 'temporary password' /var/log/mysqld.log | root@localhost:)
systemctl restart mysqld 
mysql -u root -p$temp_pass -e "create database $DB_NAME; GRANT ALL PRIVILEGES ON .* TO root@localhost IDENTIFIED BY '$db_root_password'"
yum install epel-release -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php72
yum update
yum install -y php72-php-fpm php72-php-gd php72-php-json php72-php-mbstring php72-php-mysqlnd php72-php-xml php72-php-xmlrpc php72-php-opcache

## firewall

firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --permanent --zone=public --add-port=443/{tcp,udp}
firewall-cmd --permanent --zone=public --add-port=80/{tcp,udp}
firewall-cmd --reload


}
check_dist()
{

distributor=$(hostnamectl | grep "Operating System: " | awk '{print $3}')

if [ $distributor == "Ubuntu" ]; then
    echo "This is a Ubuntu based System"
    ubuntu
else 
    echo "This is a Redhat based System"
    redhat
fi
}

check_root
check_dist

