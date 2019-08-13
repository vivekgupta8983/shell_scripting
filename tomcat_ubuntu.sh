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
    echo "Please install java !!!!!!!!! "
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
    curl -O http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.5.5/bin/apache-tomcat-8.5.5.tar.gz
    mkdir /tomcat
    tar xzvf apache-tomcat-8*tar.gz -C /tomcat --strip-components=1
    cd /tomcat
    sudo chgrp -R tomcat /tomcat
    chmod -R g+r conf
    chmod g+x conf
    chown -R tomcat webapps/ work/ temp/ logs/
}
