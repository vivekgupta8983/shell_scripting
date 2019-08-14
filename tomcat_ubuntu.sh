#!/bin/bash

### check root privilegs

check_root()
{
    if [ $(id -u) != "0" ]; then
    echo "Please Run this script in root or sudo privileges"
    fi
}

java()
{
    ##check java is install or not
    java -version
    if [ $? != "0"]; then
    echo "Please install java !!!!!!!!!"
    apt update -y
    apt install openjdk-9-jdk -y
}

create_tomcat()
{
    ## Create tomcat users
    groupadd tomcat
    useradd -s /bin/false -g tomcat -d /tomcat tomcat
    
}

download_tomcat()
{
    ### download tomcat
    cd /tmp
    wget http://apache.spinellicreations.com/tomcat/tomcat-8/v8.5.32/bin/apache-tomcat-8.5.32.tar.gz
    mkdir /tomcat
    tar xzvf apache-tomcat-8*tar.gz -C /tomcat --strip-components=1
    cd /tomcat
    chgrp -R tomcat /tomcat
    chmod -R g+r conf
    chmod g+x conf
    chown -R tomcat webapps/ work/ temp/ logs/
        
}

configure_bashrc()
{
    echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64" >> ~/.bashrc
    echo "export CATALINA_HOME=/tomcat" >> ~/.bashrc
    . ~/.bashrc
    sed -i  "<role rolename="manager-gui"/>
    <role rolename="admin-gui"/>
    <user username="username" password="password" roles="manager-gui,admin-gui"/>"
    ##to start  tomcat services
    bash $CATALINA_HOME/bin/startup.sh

}

check_root
java
download_tomcat
configure_bashrc
