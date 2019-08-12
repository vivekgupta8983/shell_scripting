#!/bin/bash
Server_Name=$(uname -n)
IP_Address=$(hostname -I| awk '{print $1}')
OS_Type=$(uname)
uptime=$(uptime | awk '{print $3 $4}')


##creating header in CSV file
echo "S_NO,Server_Name,IP_Address,OS_Type,uptime" > server_info.csv
echo "1,$Server_Name,$IP_Address,$OS_Type,$uptime" >> server_info.csv