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
    sudo apt-get remove -y docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates  curl  gnupg-agent  software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
   
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    systemctl start docker
    systemctl enable docker
    sudo groupadd docker
    sudo usermod -aG docker $USER

   sudo systemctl restart docker
    
}

Redhat()
{
    sudo yum remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

    sudo yum install -y yum-utils

   sudo yum-config-manager --add-repo     https://download.docker.com/linux/centos/docker-ce.repo    
    
    sudo yum install docker-ce docker-ce-cli containerd.io
    
    sudo systemctl start docker
    sudo systemctl enable docker
    

    sudo groupadd docker
    sudo usermod -aG docker $USER
    sudo systemctl restart docker
   
}