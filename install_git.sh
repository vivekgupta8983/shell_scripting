#!/bin/bash

## to check user is root or sudo priveleges
#if [ $(whoami) != "root" ]
#then
#    echo "Please run this Shell Scripting from root user or with sudo Privileges"
#    exit 1
#fi

if [ ($id -u) -ne 0 ]
then
    echo "Please run this Shell Scripting from root user or with sudo Privileges"
    exit 1
fi

apt-get install git vim wget -y

