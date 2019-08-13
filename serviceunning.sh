#!/bin/bash
#Script to check service is running or not


echo "Enter the service name:"
read -e service
service_name=$service

for i in service_name
  do
###CHECK SERVICE####
status=$(systemctl status $service | grep Active: | awk '{ print $2} ')
if [ $status == "active" ]; then
    echo "$service is Running"
    else
    echo "$service is Not Running"
    systemctl restart $service
    echo "$service is Running "
fi  
done