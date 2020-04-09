#!/bin/bash

distributor=$(hostnamectl | grep "Operating System: " | awk '{print $3}')

if [[ $distributor = "Ubuntu" ]]; then
    dpkg-query -l 'figlet'
    elif [[ $? != 0 ]]; then 
    sudo apt-get install -y figlet 
    elif [[] $distributor != "Ubuntu" ]]; then
    rpm -qa | grep figlet
    yum install -y figlet
else 
    echo ""
fi

#check if you are a root user
check_root()
{
if [ "$(id -u)" != "0" ]; then
    echo "Please run this script with root user or sudo privillegs"
    exit 1
fi

}

db_conf()
{
read -ep 'Strong Database Password [secretpasswd]: ' db_root_password  
echo

read -ep 'Enter the database name:' DB_NAME
echo 
}
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
 sudo a2enmod rewrite headers mcrypt  
   
 ## Install PhpMyAdmin  
 sudo apt-get install phpmyadmin -y  
   
 ## Configure PhpMyAdmin  
 echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  
   
 # Set Permissions  
 sudo chown -R www-data:www-data /var/www  
   
 # Restart Apache  
 sudo systemctl enable apache2 mysql
 sudo systemctl restart apache2 mysql

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


echo "Checking web services..."
systemctl status httpd

if [[ $? -eq 0 ]]; then
echo " web server is already installed"
else
echo "web server is not installed wait apache is installing...."
yum install -y httpd.service
systemctl restart httpd.service
fi

echo "Checking web services..."
systemctl status mysqld.service

if [[ $? -eq 0 ]]; then
echo " mysql server is already installed"
else
echo "mysql server is not installed wait apache is installing...."
yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum install -y mysql-server
systemctl restart mysqld.service
fi

echo "configuring MySQL services"
temp_pass=$(grep 'temporary password' /var/log/mysqld.log | awk ' { print $11 }' )
systemctl restart mysqld.service
mysql -u root -p$temp_pass --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$db_root_password'"
mysql -u root -p$db_root_password --connect-expired-password -e "create database $DB_NAME; GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost'"

yum install -y epel-release 
yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
yum install -y yum-utils
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
    db_conf
    ubuntu
else 
    echo "This is a Redhat based System"
    db_conf
    redhat
fi
}

wordpress()
{

clear
echo "============================================"
echo "WordPress Install Script"
echo "============================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass
echo "run install? (y/n)"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "============================================"
echo "A robot is now installing WordPress for you."
echo "============================================"


mysql -u root -p$db_root_password --connect-expired-password -e "CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass"
mysql -u root -p$db_root_password --connect-expired-password -e "create database $dbname; GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost'"

#download wordpress
#download wordpress
cur_dir=`pwd`
curl -O https://wordpress.org/latest.tar.gz
#unzip wordpress
tar -zxvf latest.tar.gz
#copy file to parent dir
cp -rf wordpress /var/www/html/
cd /var/www/html/wordpress
#create wp config
cp wp-config-sample.php wp-config.php
#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php

#set WP salts
perl -i -pe'
  BEGIN {
    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
  }
  s/put your unique phrase here/salt()/ge
' wp-config.php

#create uploads folder and set permissions
mkdir wp-content/uploads
chmod 775 wp-content/uploads
echo "Cleaning..."
#remove zip file
cd $curr_dir
rm -rf latest.tar.gz wordpress
#remove bash script
rm wp.sh
echo "========================="
echo "Installation is complete."
echo "========================="
fi

}


figlet "CLOUD2HELP"
echo "Welcome to cloud2help for Linux, DevOps, Cloud related tutorials Please visits our website http://cloud2help.com"
echo  
echo  
PS3='Enter 1 if you do not know your Linux Distributor
     Enter 2 to Install LAMP server
     Enter 3 to Install Wordpress
     Enter 4 to Install LAMP and Wordpress both
     Please enter your choice: '
options=("Option 1" "Option 2" "Option 3" "Option 4" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Option 1")
            echo "you chose choice 1"
            check_root
            check_dist
            wordpress
            break
            ;;
        "Option 2")
            echo "you chose choice 2"
            check_root
            read -ep 'Enter your Distributor'
            check_dist
            break
            ;;
        "Option 3")
            echo "Installing Wordpress"
            wordpress
            break
            ;;
        "Option 3")
            echo "Install Both LAMP Server and Wordpress"
            check_root
            check_dist
            wordpress
            break
            ;;

        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
