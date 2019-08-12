#!/bin /bash
#this is the example for addition of two number.
#we have take two number for addition as a argument


if [ $# -ne 2 ]
then
echo "please used two number as a argument for addition:"
fi


if [ $# -eq 2 ]
then
a=$1
b=$2
resutl=$((a+b))
echo "The addition of $a and $b is $resutl"
fi