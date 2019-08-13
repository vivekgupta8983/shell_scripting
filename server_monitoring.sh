#!/bin/bash
#Script for monitoring CPU Utilization
Server_Name=$(hostname)
OS_Type=$(uname)
Distributor=$(hostnamectl | grep "Operating System: " | awk '{print $3}')
CPU_Utilization=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')
Memory=$(free -mt| grep Total: | awk '{print $3}')
Disk_Usage=$(df -hT /  | grep /dev/ | awk '{ print $6 }')
UPTIME=$( uptime | awk '{ print $3 }')

echo "===================================================================================="
echo " "
echo "your Server Name is : " $Server_Name
echo " "
echo "your OS Type is $OS_Type and Distibution ID: $Distributor "
echo " "
echo "CPU Utilization : $CPU_Utilization"

THERSHOLD=80%

if [ $CPU_Utilization > $THERSHOLD ]
    then
        echo "CPU Utilization is greater than $THERSHOLD "
fi

echo "Memory usage: " $Memory

if [ $Memory > $THERSHOLD ]
    then
        echo "Memory Utilization is greater than $THERSHOLD "
    else
        echo "Memory Utilization is Less than $THERSHOLD"
fi

echo "DISK usage: " $Disk_Usage

if [ $Disk_Usage > $THERSHOLD ]
    then
        echo "Disk Usage is greater than $THERSHOLD "
    else
        echo "Disk Usage is Less than $THERSHOLD"
fi


echo "Server Running from $UPTIME"