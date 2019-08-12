#!/bin/bash

TO="vivek.gupta8983@gmail.com"
ram_free=$(free -mt | grep Total:| awk '{print $4}')

if [ $ram_free -le 2000 ]
then
    echo "Sending mail because your ram free size is less than 2000"
    echo "subjetc : warning Ram free size is Low" | sendmail $TO
fi
