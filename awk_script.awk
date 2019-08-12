BEGIN {
	 print "================ working on /etc/passswd file ==============";
} 
/root/ { 
	print $0;
 } 
END { 
print "=======================Completed===================";
} 

