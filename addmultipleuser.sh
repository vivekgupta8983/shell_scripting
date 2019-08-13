#!/bin/bash
## script to create mutiple users
set -x
userlist=$(more userlist.txt)
    /bin/egrep  -i "^${userlist}:" /etc/passwd
if [ $? -eq 0 ]; then
   echo "User $userlist exists in /etc/passwd"
else 
    echo "User $userlist does not exists in /etc/passwd"
    adduser -aG sudo $i
    echo "user $i added successfully!"
    echo -e "linux123" | passwd "$i"
    passwd --expire $i
    echo "Password for $i changed successfully"
fi

