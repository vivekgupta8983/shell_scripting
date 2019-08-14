#!/bin/bash
#How to install docker and configure kubernetes

if [ $(id -u) != "0" ]; then 
echo "Please this script with root or sudo privilegs"
fi

dist()
{
    distributor=$(hostnamectl | grep System: | awk '{print $3}')
    if [ $distributor = "Ubuntu"] || [ $distributor = "Debian" ]
    then 
        echo " This is Ubuntu Distributor"
        ubuntu
    elif [ $distributor = "Redhat"] || [ $distributor = "CentOS" ]
    then
        echo "This is Redhat OS"
        Redhat
    else 
        echo "Please run this script in Ubuntu, Redhat, CentOS"
    fi
}


ubuntu()
{
    docker -v
    if [ $? != "0"]
    then
    echo " "
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
    fi
}

Redhat()
{
    docker -v
    if [ $? != "0"]
    then
    echo " "
    yum  install -y docker.io
    systemctl start docker
    systemctl enable docker
    fi
}